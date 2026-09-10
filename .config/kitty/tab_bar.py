#!/usr/bin/env python3
"""Custom kitty vertical tab bar: groups tabs into sections (regular, agent,
k8s, ssh, ...), colours each section, divides them, and keeps kitty's real
tab order in sync with the section order so ctrl+shift+left/right and
goto_tab N follow the grouping.

To add a new section: add ONE Section(...) entry to SECTIONS below.
"""
from collections.abc import Callable, Sequence
from dataclasses import dataclass
from typing import Any

from kitty.fast_data_types import Screen, get_boss, wcswidth, add_timer
from kitty.tab_bar import (
    CellRange,
    DrawData,
    ExtraData,
    TabBar,
    TabBarData,
    TabExtent,
    as_rgb,
    color_as_int,
    draw_title,
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
    matcher: Matcher = lambda tab, haystacks: False  # noqa: E731


def _has_any(haystacks: list[str], needles: tuple[str, ...]) -> bool:
    return any(n in h for h in haystacks for n in needles)


SECTIONS: tuple[Section, ...] = (
    Section("agent", "AGENTS", 0xaedde7,
            lambda tab, h: _has_any(h, ("copilot", "agy"))),
    Section("k8s", "K8S", 0xdbb791,
            lambda tab, h: _has_any(h, ("kubectl", "k9s"))),
    Section("ssh", "SSH", 0xdf9cc3,
            lambda tab, h: _has_any(h, ("ssh ", "ssh://"))),
    # Add more here, e.g.:
    # Section("docker", "DOCKER", 0x50fa7b,
    #         lambda tab, h: _has_any(h, ("docker", "docker-compose", "lazydocker"))),
)

DEFAULT_SECTION = Section("regular", "TABS", 0xcfcfc7)
URGENT_COLOR = 0xff5555  # overrides section colour when needs_attention

DIVIDER_FG = 0x44475a
DIVIDER_CHAR = "─"

DISPLAY_ORDER: tuple[str, ...] = ("regular",) + tuple(s.key for s in SECTIONS)
_SECTIONS_BY_KEY = {s.key: s for s in (DEFAULT_SECTION, *SECTIONS)}


def _display_order() -> list[str]:
    order = list(DISPLAY_ORDER)
    for s in SECTIONS:
        if s.key not in order:
            order.append(s.key)
    return order


# --------------------------------------------------------------------------
# Classification helpers
# --------------------------------------------------------------------------

def _fit_text(text: str, max_width: int) -> str:
    if max_width <= 0:
        return ""
    cur_width = 0
    chars = []
    for ch in text:
        w = max(0, wcswidth(ch))
        if cur_width + w > max_width:
            if chars:
                chars[-1] = "…"
            break
        chars.append(ch)
        cur_width += w
    res = "".join(chars)
    total_w = sum(max(0, wcswidth(c)) for c in res)
    return res + " " * max(0, max_width - total_w)


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


def _classify(tab: TabBarData, boss: Any) -> Section:
    haystacks = _foreground_cmdlines(tab, boss) + [tab.title]
    for section in SECTIONS:
        if section.matcher(tab, haystacks):
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

_last_order: dict[int, tuple[int, ...]] = {}  # os_window_id -> tab id order
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
    for target_idx, tab_id in enumerate(desired_ids):
        tab = id_to_tab.get(tab_id)
        if tab is None:
            continue
        current_idx = tm.tabs.index(tab)
        if current_idx == target_idx:
            continue
        tm.set_active_tab(tab)
        delta = target_idx - current_idx
        step = 1 if delta > 0 else -1
        for _ in range(abs(delta)):
            tm.move_tab(step)
    if original_active is not None and original_active in tm.tabs:
        tm.set_active_tab(original_active)


def _reorder_if_needed(bar: TabBar, boss: Any, groups: dict[str, list[tuple[int, TabBarData]]]) -> None:
    global _reorder_lock
    if _reorder_lock or boss is None:
        return
    try:
        tm = _tab_manager_for_bar(bar, boss)
        if tm is None:
            return
        os_window_id = getattr(tm, "os_window_id", id(tm))
        current_ids = tuple(t.id for t in tm.tabs)
        desired_ids = tuple(_target_id_order(groups))
        if not desired_ids or current_ids == desired_ids:
            _last_order[os_window_id] = current_ids
            return
        _reorder_lock = True
        _apply_order(tm, desired_ids)
        _last_order[os_window_id] = desired_ids
    except Exception:
        # Any API mismatch on this kitty version: skip reordering silently.
        # Rendering below is completely unaffected.
        pass
    finally:
        _reorder_lock = False


# --------------------------------------------------------------------------
# Vertical tab bar renderer
# --------------------------------------------------------------------------

def _custom_update_vertical(self: TabBar, data: Sequence[TabBarData]) -> bool:
    s = self.screen
    self.last_laid_out_tabs = data
    self.tab_extents = ()
    s.cursor.x = 0
    s.cursor.y = 0
    s.erase_in_display(2, False)

    if not data:
        self._update_edge_defaults(True)
        return True

    cols = s.columns
    lines = s.lines
    cr: list[TabExtent] = []
    boss = get_boss()

    groups = _group_tabs(data, boss)
    _reorder_if_needed(self, boss, groups)

    default_bg = as_rgb(color_as_int(self.draw_data.default_bg))
    curr_row = 0
    first_section = True

    for key in _display_order():
        tab_list = groups.get(key)
        if not tab_list or curr_row >= lines:
            continue

        section = _SECTIONS_BY_KEY[key]
        color = as_rgb(section.color)

        if not first_section and curr_row < lines:
            s.cursor.x = 0
            s.cursor.y = curr_row
            s.cursor.bg = default_bg
            s.cursor.fg = as_rgb(DIVIDER_FG)
            s.cursor.bold = False
            s.draw(_fit_text(DIVIDER_CHAR * cols, cols))
            curr_row += 1
        first_section = False
        if curr_row >= lines:
            break

        s.cursor.x = 0
        s.cursor.y = curr_row
        s.cursor.bg = default_bg
        s.cursor.fg = color
        s.cursor.bold = True
        s.cursor.italic = False
        s.draw(_fit_text(f" {section.label}", cols))
        curr_row += 1

        for idx, tab in tab_list:
            if curr_row >= lines:
                break

            s.cursor.x = 0
            s.cursor.y = curr_row

            urgent = tab.needs_attention
            if tab.is_active:
                s.cursor.bg = as_rgb(self.draw_data.tab_bg(tab))
                s.cursor.fg = as_rgb(URGENT_COLOR) if urgent else as_rgb(self.draw_data.tab_fg(tab))
            else:
                s.cursor.bg = default_bg
                s.cursor.fg = as_rgb(URGENT_COLOR) if urgent else color
            s.cursor.bold = tab.is_active or urgent
            s.cursor.italic = False

            marker = "●" if tab.is_active else "○"
            bell = "🔔 " if urgent else ""
            s.draw(_fit_text(f"  {marker} {bell}{idx}: {tab.title}", cols))

            cr.append(
                TabExtent(
                    tab_id=tab.tab_id,
                    x=CellRange(0, cols - 1),
                    y=CellRange(curr_row, curr_row),
                )
            )
            curr_row += 1

    if curr_row < lines:
        s.cursor.x = 0
        s.cursor.y = curr_row
        s.cursor.bg = default_bg
        s.erase_in_display(0, False)

    self.tab_extents = tuple(cr)
    self._update_edge_defaults(True)
    return True


TabBar.update_vertical = _custom_update_vertical

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
            pass  # fails soft if this method changes name in a future kitty


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
    sname = _classify(tab, get_boss()).label
    prefix = f"[{sname}] " if sname != DEFAULT_SECTION.label else ""
    screen.draw(prefix)
    return draw_title(draw_data, screen, tab, index)


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
