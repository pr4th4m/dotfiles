#!/usr/bin/env python3
"""Custom kitty horizontal tab bar (tab_bar_edge top/bottom, tab_bar_style custom).

Groups tabs into sections (regular, agent, k8s, ssh, ...), colours each
section, gives each section its own background "pill", and keeps kitty's
real tab order in sync with the section order so ctrl+shift+left/right and
goto_tab N follow the grouping.

Layout (each section sits on its own tinted background):
  [ T: 1: nvim | 2: cat ]  ║  [ A: 3: copilot | 4: agy ]  ║  [ S: 5: ssh m1 ]

kitty.conf:
  tab_bar_edge   top
  tab_bar_style  custom
  tab_bar_align  center      # or left / right
  tab_bar_min_tabs 1

To add a new section: add ONE Section(...) entry to SECTIONS below.
The background is derived automatically from the section colour; pass
bg=0xRRGGBB to Section(...) to override it.
"""
from collections.abc import Callable, Sequence
from dataclasses import dataclass
import os
from typing import Any

from kitty.fast_data_types import Screen, add_timer, get_boss, wcswidth, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBar,
    TabBarData,
    as_rgb,
    color_as_int,
)

# --------------------------------------------------------------------------
# Section registry — the only place you need to touch to add a category.
# --------------------------------------------------------------------------

Matcher = Callable[[TabBarData, list[str]], bool]


@dataclass(frozen=True)
class Section:
    key: str
    label: str
    color: int  # 0xRRGGBB, used for text / active tab highlight
    matcher: Matcher = lambda tab, haystacks: False
    bg: int | None = None  # optional explicit background; auto-derived if None


def _has_any(haystacks: list[str], needles: tuple[str, ...]) -> bool:
    return any(n in h for h in haystacks for n in needles)


SECTIONS: tuple[Section, ...] = (
    Section("agent", "A", 0xaedde7,
            lambda tab, h: _has_any(h, ("copilot", "agy"))),
    Section("k8s", "K", 0xc78591,
            lambda tab, h: _has_any(h, ("k9s", "kubectl"))),
    Section("ssh", "S", 0xc89a62,
            lambda tab, h: _has_any(h, ("ssh ", "ssh://"))),
    # Add more here, e.g.:
    # Section("docker", "Docker", 0x50fa7b,
    #         lambda tab, h: _has_any(h, ("docker", "docker-compose", "lazydocker"))),
    # Or with a hand-picked background:
    # Section("db", "D", 0xf1fa8c, lambda tab, h: _has_any(h, ("psql",)), bg=0x3a3a1e),
)

DEFAULT_SECTION = Section("regular", "T", 0x979eab)
URGENT_COLOR = 0xff5555  # overrides section colour when needs_attention

DIVIDER_FG = 0x6272a4
TAB_SEPARATOR = "|"      # between tabs of the same section
SECTION_SEPARATOR = "║"  # between sections

# How strongly the section colour is mixed into the bar background to form the
# section's own background. 0.0 = no tint, 1.0 = solid section colour.
SECTION_BG_MIX = 0.18
# Active tab: True -> solid section colour bg with dark text (clear highlight),
# False -> use kitty's own active tab colours (active_tab_background etc.).
ACTIVE_TAB_USES_SECTION_COLOR = True

DISPLAY_ORDER: tuple[str, ...] = ("regular",) + tuple(s.key for s in SECTIONS)


def _display_order() -> list[str]:
    order = list(DISPLAY_ORDER)
    for s in SECTIONS:
        if s.key not in order:
            order.append(s.key)
    return order


# --------------------------------------------------------------------------
# Colour helpers
# --------------------------------------------------------------------------

def _blend(fg: int, bg: int, alpha: float) -> int:
    """Mix fg over bg: alpha=0 -> bg, alpha=1 -> fg. Both are 0xRRGGBB ints."""
    out = 0
    for shift in (16, 8, 0):
        f = (fg >> shift) & 0xFF
        b = (bg >> shift) & 0xFF
        out |= int(round(b + (f - b) * alpha)) << shift
    return out


def _section_bg(section: Section, bar_bg: int) -> int:
    if section.bg is not None:
        return section.bg
    return _blend(section.color, bar_bg, SECTION_BG_MIX)


# --------------------------------------------------------------------------
# Classification helpers
# --------------------------------------------------------------------------

def _truncate(text: str, max_width: int) -> str:
    """Truncate to max_width cells, ending with an ellipsis if cut."""
    if max_width <= 0:
        return ""
    if wcswidth(text) <= max_width:
        return text
    out: list[str] = []
    width = 0
    for ch in text:
        w = max(0, wcswidth(ch))
        if width + w > max_width - 1:
            break
        out.append(ch)
        width += w
    return "".join(out) + "…"


def _foreground_cmdlines(tab: TabBarData, boss: Any) -> list[str]:
    if boss is None:
        return []
    try:
        real_tab = boss.tab_for_id(tab.tab_id)
        window = real_tab.active_window if real_tab else None
        procs = window.child.foreground_processes if window else []
        return [" ".join(p.get("cmdline") or []) for p in procs]
    except Exception:
        return []


_renamed_agent_tabs: set[int] = set()


def _rename_agent_tab_once(tab: TabBarData, boss: Any) -> None:
    if boss is None or tab.tab_id in _renamed_agent_tabs:
        return
    _renamed_agent_tabs.add(tab.tab_id)
    try:
        real_tab = boss.tab_for_id(tab.tab_id)
        window = real_tab.active_window if real_tab else None
        cwd = window.get_cwd_of_child() if window else None
        if cwd:
            real_tab.set_title(os.path.basename(cwd.rstrip("/")))
    except Exception:
        pass


def _classify(tab: TabBarData, boss: Any) -> Section:
    haystacks = _foreground_cmdlines(tab, boss) + [tab.title]
    for section in SECTIONS:
        if section.matcher(tab, haystacks):
            if section.key == "agent":
                _rename_agent_tab_once(tab, boss)
            return section
    return DEFAULT_SECTION


def _group_tabs(
    data: Sequence[TabBarData], boss: Any
) -> dict[str, list[tuple[int, TabBarData]]]:
    groups: dict[str, list[tuple[int, TabBarData]]] = {}
    for i, tab in enumerate(data):
        groups.setdefault(_classify(tab, boss).key, []).append((i + 1, tab))
    return groups


# --------------------------------------------------------------------------
# Dynamic physical reordering — best-effort, never breaks rendering.
# Uses only the same active-tab-based "move by one" primitive kitty's own
# move_tab_forward / move_tab_backward keybindings use.
# --------------------------------------------------------------------------

_reorder_lock = False


def _tab_manager_for_bar(bar: TabBar, boss: Any) -> Any:
    for tm in getattr(boss, "all_tab_managers", ()):
        if getattr(tm, "tab_bar", None) is bar:
            return tm
    return None


def _target_id_order(groups: dict[str, list[tuple[int, TabBarData]]]) -> list[int]:
    order: list[int] = []
    for key in _display_order():
        for _, tab in groups.get(key, []):
            order.append(tab.tab_id)
    return order


def _apply_order(tm: Any, desired_ids: Sequence[int]) -> None:
    original_active = tm.active_tab
    # Reordering goes through set_active_tab()/move_tab(), which push entries
    # onto the history used by `goto_tab -1`. Save it and restore it after.
    history = getattr(tm, "active_tab_history", None)
    saved_history = list(history) if history is not None else None
    try:
        id_to_tab = {t.id: t for t in tm.tabs}
        max_steps = len(tm.tabs)
        for target_idx, tab_id in enumerate(desired_ids):
            tab = id_to_tab.get(tab_id)
            if tab is None:
                continue
            if tm.tabs.index(tab) == target_idx:
                continue
            tm.set_active_tab(tab)
            for _ in range(max_steps):
                current_idx = tm.tabs.index(tab)
                if current_idx == target_idx:
                    break
                tm.move_tab(1 if target_idx > current_idx else -1)
        if original_active is not None and original_active in tm.tabs:
            tm.set_active_tab(original_active)
    finally:
        if history is not None and saved_history is not None:
            history.clear()
            history.extend(saved_history)


def _reorder_if_needed(
    bar: TabBar, boss: Any, groups: dict[str, list[tuple[int, TabBarData]]]
) -> None:
    global _reorder_lock
    if _reorder_lock or boss is None:
        return
    try:
        tm = _tab_manager_for_bar(bar, boss)
        if tm is None:
            return
        current_ids = tuple(t.id for t in tm.tabs)
        desired_ids = tuple(_target_id_order(groups))
        if not desired_ids or current_ids == desired_ids:
            return
        _reorder_lock = True
        _apply_order(tm, desired_ids)
    except Exception:
        pass  # API mismatch on this kitty version: skip reordering silently
    finally:
        _reorder_lock = False


# Hook TabBar.update so reordering happens before every (re)draw. Drawing
# itself is done per-tab by draw_tab() below, in kitty's physical order,
# which the reordering above keeps grouped by section.
_orig_update = getattr(TabBar, "update", None)


if _orig_update is not None:
    def _update_with_reorder(self: TabBar, data: Sequence[TabBarData]) -> Any:
        try:
            boss = get_boss()
            if boss is not None and data:
                _reorder_if_needed(self, boss, _group_tabs(data, boss))
        except Exception:
            pass
        return _orig_update(self, data)

    TabBar.update = _update_with_reorder  # type: ignore[method-assign]


# --------------------------------------------------------------------------
# Periodic refresh (foreground process changes don't trigger a redraw)
# --------------------------------------------------------------------------

_REFRESH_INTERVAL = 0.1  # seconds; lower = snappier, marginally more CPU
_timer_started = False


def _redraw_all_tab_bars(timer_id: int = 0) -> None:
    boss = get_boss()
    if boss is None:
        return
    for tm in boss.all_tab_managers:
        try:
            tm.mark_tab_bar_dirty()
        except Exception:
            pass


def _ensure_periodic_refresh() -> None:
    global _timer_started
    if _timer_started:
        return
    _timer_started = True
    try:
        add_timer(_redraw_all_tab_bars, _REFRESH_INTERVAL, True)
    except Exception:
        pass


_ensure_periodic_refresh()


# --------------------------------------------------------------------------
# Horizontal renderer: kitty calls this once per tab, left to right.
# Alignment (tab_bar_align left/center/right) is handled by kitty itself.
#
# Each section is painted as one continuous block on its own background:
#   <pad><label><tab><sep><tab>...<pad>
# Between two sections the bar's default background shows through, with the
# SECTION_SEPARATOR drawn in the middle.
# --------------------------------------------------------------------------

_prev_section: Section | None = None


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global _prev_section

    section = _classify(tab, get_boss())
    if index == 1:
        _prev_section = None
    prev = _prev_section
    new_section = prev is None or prev.key != section.key
    _prev_section = section

    bar_bg_i = color_as_int(draw_data.default_bg)
    bar_bg = as_rgb(bar_bg_i)
    color = as_rgb(section.color)
    sec_bg_i = _section_bg(section, bar_bg_i)
    sec_bg = as_rgb(sec_bg_i)
    urgent = tab.needs_attention

    cur = screen.cursor
    cur.italic = False
    cur.bold = False

    if index > 1:
        if new_section and prev is not None:
            # Close the previous section's block with a padding cell ...
            cur.bg = as_rgb(_section_bg(prev, bar_bg_i))
            screen.draw(" ")
            # ... then the divider on the plain bar background.
            cur.bg = bar_bg
            cur.fg = as_rgb(DIVIDER_FG)
            screen.draw(f" {SECTION_SEPARATOR} ")
        else:
            # Same-section separator, drawn on the section's own background,
            # in a softened version of the section colour.
            cur.bg = sec_bg
            cur.fg = as_rgb(_blend(section.color, sec_bg_i, 0.45))
            screen.draw(f"{TAB_SEPARATOR}")

    if new_section:
        # Leading pad + section label, both on the section background.
        cur.bg = sec_bg
        cur.fg = color
        cur.bold = True
        screen.draw(f" {section.label}: ")

    # The tab itself
    bell = "🔔 " if urgent else ""
    prefix = f"{bell}{index}:"
    room = max_title_length - wcswidth(prefix)
    # Never run past the right edge of the bar (keep 1 cell for trailing pad)
    reserve = 1 if is_last else 0
    room = min(room, screen.columns - screen.cursor.x - wcswidth(prefix) - reserve)

    # Honour kitty.conf `tab_title_max_length` (applies to the title text only)
    limit = _configured_title_limit()
    if limit > 0:
        room = min(room, limit)

    title = _truncate(tab.title, max(1, room))

    if tab.is_active:
        if ACTIVE_TAB_USES_SECTION_COLOR:
            cur.bg = color if not urgent else as_rgb(URGENT_COLOR)
            cur.fg = bar_bg  # dark text on the bright section colour
        else:
            cur.bg = as_rgb(draw_data.tab_bg(tab))
            cur.fg = as_rgb(URGENT_COLOR) if urgent else as_rgb(draw_data.tab_fg(tab))
    else:
        cur.bg = sec_bg
        cur.fg = as_rgb(URGENT_COLOR) if urgent else color
    cur.bold = tab.is_active or urgent
    screen.draw(f"{prefix}{title}")

    # Trailing pad closes the last section's block
    if is_last:
        cur.bold = False
        cur.bg = sec_bg
        screen.draw(" ")

    cur.bold = False
    cur.bg = bar_bg
    return screen.cursor.x

def _configured_title_limit() -> int:
    """Value of kitty.conf `tab_title_max_length` (0 = unlimited)."""
    try:
        return int(getattr(get_options(), "tab_title_max_length", 0) or 0)
    except Exception:
        return 0


def main(args: list[str]) -> None:
    boss = get_boss()
    if not boss:
        return
    for tm in boss.all_tab_managers:
        for tab in tm.tabs:
            data = tab.data_for_tab_bar(tab is tm.active_tab)
            section = _classify(data, boss)
            status = "*" if data.is_active else " "
            print(f"[{section.label}] {status} {data.tab_id}: {data.title}")
