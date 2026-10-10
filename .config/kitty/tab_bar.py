#!/usr/bin/env python3
"""Custom kitty horizontal tab bar (tab_bar_edge top/bottom, tab_bar_style custom).

Groups tabs into sections (regular, agent, k8s, ssh, ...), colours each
section, and keeps kitty's real tab order in sync with the section order so
ctrl+shift+left/right and goto_tab N follow the grouping.

Layout:
  Tabs: 1: nvim | 2: cat | 3: git ==== Agents: 4: copilot | 5: agy ==== SSH: 6: ssh m1

kitty.conf:
  tab_bar_edge   top
  tab_bar_style  custom
  tab_bar_align  center      # or left / right
  tab_bar_min_tabs 1

To add a new section: add ONE Section(...) entry to SECTIONS below.
"""
from collections.abc import Callable, Sequence
from dataclasses import dataclass
import os
from typing import Any

from kitty.fast_data_types import Screen, add_timer, get_boss, wcswidth
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
    color: int  # 0xRRGGBB
    matcher: Matcher = lambda tab, haystacks: False


def _has_any(haystacks: list[str], needles: tuple[str, ...]) -> bool:
    return any(n in h for h in haystacks for n in needles)


SECTIONS: tuple[Section, ...] = (
    Section("agent", "Agents", 0xaedde7,
            lambda tab, h: _has_any(h, ("copilot", "agy"))),
    Section("k8s", "K8s", 0xdbb791,
            lambda tab, h: _has_any(h, ("k9s", "kubectl"))),
    Section("ssh", "SSH", 0xdf9cc3,
            lambda tab, h: _has_any(h, ("ping ", "ssh://"))),
    # Add more here, e.g.:
    # Section("docker", "Docker", 0x50fa7b,
    #         lambda tab, h: _has_any(h, ("docker", "docker-compose", "lazydocker"))),
)

DEFAULT_SECTION = Section("regular", "Tabs", 0x979eab)
URGENT_COLOR = 0xff5555  # overrides section colour when needs_attention

DIVIDER_FG = 0x6272a4
TAB_SEPARATOR = "|"      # between tabs of the same section
SECTION_SEPARATOR = "║"  # between sections

DISPLAY_ORDER: tuple[str, ...] = ("regular",) + tuple(s.key for s in SECTIONS)


def _display_order() -> list[str]:
    order = list(DISPLAY_ORDER)
    for s in SECTIONS:
        if s.key not in order:
            order.append(s.key)
    return order


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
    id_to_tab = {t.id: t for t in tm.tabs}
    max_steps = len(tm.tabs)
    for target_idx, tab_id in enumerate(desired_ids):
        tab = id_to_tab.get(tab_id)
        if tab is None:
            continue
        if tm.tabs.index(tab) == target_idx:
            continue
        tm.set_active_tab(tab)
        # Recompute the live index before every single step: move_tab()
        # wraps around at the ends, so drift could otherwise send a tab to
        # the far end of the list.
        for _ in range(max_steps):
            current_idx = tm.tabs.index(tab)
            if current_idx == target_idx:
                break
            tm.move_tab(1 if target_idx > current_idx else -1)
    if original_active is not None and original_active in tm.tabs:
        tm.set_active_tab(original_active)


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
# --------------------------------------------------------------------------

_prev_section_key: str | None = None


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
    global _prev_section_key

    section = _classify(tab, get_boss())
    if index == 1:
        _prev_section_key = None
    new_section = _prev_section_key != section.key
    _prev_section_key = section.key

    default_bg = as_rgb(color_as_int(draw_data.default_bg))
    color = as_rgb(section.color)
    urgent = tab.needs_attention

    cur = screen.cursor
    cur.italic = False

    # Separator before this tab (none before the very first one)
    overhead = 0
    if index > 1:
        sep = f" {SECTION_SEPARATOR} " if new_section else f" {TAB_SEPARATOR} "
        cur.bg = default_bg
        cur.fg = as_rgb(DIVIDER_FG)
        cur.bold = False
        screen.draw(sep)
        overhead += wcswidth(sep)

    # Section label at the start of each section
    if new_section:
        label = f"{section.label}: "
        cur.bg = default_bg
        cur.fg = color
        cur.bold = True
        screen.draw(label)
        overhead += wcswidth(label)

    # The tab itself
    bell = "🔔 " if urgent else ""
    prefix = f"{bell}{index}: "
    room = max_title_length - wcswidth(prefix)
    # Never run past the right edge of the bar
    room = min(room, screen.columns - screen.cursor.x - wcswidth(prefix))
    title = _truncate(tab.title, max(1, room))

    if tab.is_active:
        cur.bg = as_rgb(draw_data.tab_bg(tab))
        cur.fg = as_rgb(URGENT_COLOR) if urgent else as_rgb(draw_data.tab_fg(tab))
    else:
        cur.bg = default_bg
        cur.fg = as_rgb(URGENT_COLOR) if urgent else color
    cur.bold = tab.is_active or urgent
    screen.draw(f"{prefix}{title}")

    cur.bold = False
    cur.bg = default_bg
    return screen.cursor.x


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
