#!/usr/bin/env python3
"""Custom kitty tab bar: colours each tab by section, shows the session name.

kitty.conf:
  tab_bar_style  custom
  tab_bar_filter session:~ or session:^$

To add a section: add ONE Section(...) entry to SECTIONS below.
"""

from collections.abc import Callable
from dataclasses import dataclass
from functools import lru_cache
import os
from typing import Any

from kitty.fast_data_types import Screen, add_timer, get_boss, get_options, wcswidth
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, color_as_int

Matcher = Callable[[list[str]], bool]


@dataclass(frozen=True)
class Section:
    key: str
    bg: int  # background of inactive tabs (muted)
    active: int  # background of the active tab
    matcher: Matcher = lambda haystacks: False


def _has_any(*needles: str) -> Matcher:
    return lambda haystacks: any(n in h for h in haystacks for n in needles)


SECTIONS: tuple[Section, ...] = (
    Section("agent", 0x5E4434, 0xA06A47, _has_any("copilot")),
    Section("k8s", 0x30495F, 0x4676A0, _has_any("k9s")),
    Section("ssh", 0x334F3D, 0x52845E, _has_any("ssh ")),
)
DEFAULT_SECTION = Section("regular", 0x414753, 0x656D7D)
URGENT_BG = 0x7A2E2E
FG = 0xC8CCD4  # inactive tab text
ACTIVE_FG = 0xF2EFE8  # active tab text (off-white)
SEPARATOR_FG = 0x6272A4
TAB_SEPARATOR = " "

SHOW_SESSION_NAME = True
SESSION_COLOR = 0xD7BAFF
SESSION_BG = 0x6E4FA3

REFRESH_INTERVAL = 1.0  # seconds; redraw so foreground process changes show up


# --------------------------------------------------------------------------
# Classification
# --------------------------------------------------------------------------

try:
    from kitty.child import cmdline_of_pid, process_group_map
except Exception:  # pragma: no cover
    cmdline_of_pid = process_group_map = None

# Process group map is read once per tab bar redraw (see draw_tab), not per tab.
_pgroups: dict[int, list[int]] = {}


def _foreground_cmdlines(window: Any) -> list[str]:
    # Every process in the foreground group (a wrapper script may lead the
    # group, e.g. `k9s` started from a shell function or script). Skips the
    # per-process cwd lookup that makes child.foreground_processes slow.
    try:
        pgrp = os.tcgetpgrp(window.child.child_fd)
        if pgrp <= 0 or cmdline_of_pid is None:
            return []
    except Exception:
        return []
    out = []
    for pid in _pgroups.get(pgrp) or (pgrp,):
        try:
            out.append(" ".join(cmdline_of_pid(pid)))
        except Exception:
            pass
    return out


def _classify(tab: TabBarData) -> Section:
    haystacks = [tab.title]
    boss = get_boss()
    if boss is not None:
        t = boss.tab_for_id(tab.tab_id)
        if t is not None and t.active_window is not None:
            haystacks += _foreground_cmdlines(t.active_window)
    for section in SECTIONS:
        if section.matcher(haystacks):
            return section
    return DEFAULT_SECTION


@lru_cache(maxsize=512)
def _truncate(text: str, max_width: int) -> str:
    if max_width <= 0:
        return ""
    if wcswidth(text) <= max_width:
        return text
    out, width = [], 0
    for ch in text:
        w = max(0, wcswidth(ch))
        if width + w > max_width - 1:
            break
        out.append(ch)
        width += w
    return "".join(out) + "…"


# --------------------------------------------------------------------------
# Sessions
# --------------------------------------------------------------------------


def _current_session_name(tab: TabBarData) -> str:
    """Active session, or (like tab_bar_filter) the most recent one."""
    try:
        from kitty.session import append_to_session_history, most_recent_session

        boss = get_boss()
        name = getattr(boss, "active_session", "") if boss is not None else ""
        # Keep kitty's session history in sync with the focused window, so
        # `session:~` does not mix tabs of two sessions after jumping between
        # them by other means than goto_session (tab pickers, goto_tab, ...).
        if name and name != most_recent_session():
            append_to_session_history(name)
        return name or most_recent_session()
    except Exception:
        return getattr(tab, "active_session_name", "") or getattr(
            tab, "session_name", ""
        )


# kitty's `goto_tab -1` walks a global history ignoring tab_bar_filter, so it
# can jump into another session. Restrict it to the tabs shown in the bar.
try:
    from kitty.tabs import TabManager as _TabManager

    _orig_goto_tab = _TabManager.goto_tab

    def _goto_tab_in_session(self: Any, tab_num: int) -> None:
        if tab_num >= 0 or not get_options().tab_bar_filter:
            return _orig_goto_tab(self, tab_num)
        visible = {t.id for t in self.tabs_to_be_shown_in_tab_bar}
        at = self.active_tab
        candidates: list[int] = []
        for tid in reversed(self.active_tab_history):
            if (
                tid in visible
                and tid not in candidates
                and (at is None or tid != at.id)
            ):
                candidates.append(tid)
        if candidates:
            tab = self.tab_for_id(candidates[min(-tab_num, len(candidates)) - 1])
            if tab is not None:
                self.set_active_tab(tab)

    _TabManager.goto_tab = _goto_tab_in_session  # type: ignore[method-assign]

except Exception:
    pass


# Tabs created without a session (new_tab, `launch --type=tab`, scripts)
# match `session:^$` and would show up in every session. Adopt them into the
# session that is active (or most recent) when they are created.
def _session_for_new_tab() -> str:
    try:
        from kitty.session import most_recent_session

        boss = get_boss()
        return (
            getattr(boss, "active_session", "") if boss else ""
        ) or most_recent_session()
    except Exception:
        return ""


try:
    import kitty.launch as _launch

    _orig_tab_for_window = _launch.tab_for_window

    def _tab_for_window(
        boss: Any, opts: Any, target_tab: Any, next_to: Any, add_to_session: str
    ) -> Any:
        if not add_to_session and getattr(opts, "type", "") in ("tab", "os-window"):
            add_to_session = _session_for_new_tab()
        return _orig_tab_for_window(boss, opts, target_tab, next_to, add_to_session)

    _launch.tab_for_window = _tab_for_window
except Exception:
    pass

try:
    _orig_new_tab = _TabManager.new_tab

    def _new_tab_in_session(self: Any, *args: Any, **kwargs: Any) -> Any:
        session = _session_for_new_tab()
        tab = _orig_new_tab(self, *args, **kwargs)
        try:
            if session and tab is not None and not tab.created_in_session_name:
                tab.created_in_session_name = session
                for w in tab:
                    w.created_in_session_name = w.created_in_session_name or session
        except Exception:
            pass
        return tab

    _TabManager.new_tab = _new_tab_in_session  # type: ignore[method-assign]
except Exception:
    pass


# --------------------------------------------------------------------------
# Periodic refresh (foreground process changes don't trigger a redraw)
# --------------------------------------------------------------------------


def _redraw_all_tab_bars(timer_id: int = 0) -> None:
    boss = get_boss()
    if boss is not None:
        for tm in boss.all_tab_managers:
            tm.mark_tab_bar_dirty()


if not globals().get("_timer_started"):
    _timer_started = True
    try:
        add_timer(_redraw_all_tab_bars, REFRESH_INTERVAL, True)
    except Exception:
        pass


# --------------------------------------------------------------------------
# Renderer
# --------------------------------------------------------------------------


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
    global _pgroups
    bar_bg = as_rgb(color_as_int(draw_data.default_bg))
    cur = screen.cursor
    cur.italic = False

    if index == 1 and process_group_map is not None:
        try:
            _pgroups = process_group_map()
        except Exception:
            _pgroups = {}

    if index == 1 and SHOW_SESSION_NAME:
        name = _current_session_name(tab)
        if name:
            cur.bg, cur.fg, cur.bold = as_rgb(SESSION_BG), as_rgb(SESSION_COLOR), True
            screen.draw(f" {_truncate(name, 20)} ")
            cur.bg, cur.bold = bar_bg, False
            screen.draw(" ")

    if index > 1:
        cur.bg, cur.fg, cur.bold = bar_bg, as_rgb(SEPARATOR_FG), False
        screen.draw(TAB_SEPARATOR)

    section = _classify(tab)
    urgent = tab.needs_attention
    prefix = f"{index}: "
    room = min(max_title_length, screen.columns - screen.cursor.x - 2) - len(prefix)
    limit = int(getattr(get_options(), "tab_title_max_length", 0) or 0)
    if limit > 0:
        room = min(room, limit)
    title = _truncate(tab.title, max(1, room))

    if urgent:
        cur.bg = as_rgb(URGENT_BG)
    else:
        cur.bg = as_rgb(section.active if tab.is_active else section.bg)
    cur.fg = as_rgb(ACTIVE_FG if tab.is_active else FG)
    cur.bold = tab.is_active or urgent
    screen.draw(f" {prefix}{title} ")

    cur.bg, cur.bold = bar_bg, False
    return screen.cursor.x
