"""
search.py — Incremental search kitten for kitty terminal emulator.

Kitty pipes the scrollback buffer to the kitten's stdin; the kitten renders
an interactive search UI, and on exit returns the chosen line number so
handle_result() can scroll the *real* window.

Install (kitty.conf):
    map ctrl+shift+f combine : show_scrollback : kitten search.py
  or the simpler alias:
    map ctrl+shift+f launch --type=overlay --allow-remote-control kitty +kitten search.py
"""

from __future__ import annotations

import os
import re
import shutil
import sys
import termios
import tty
from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List, Optional, Tuple

# ---------------------------------------------------------------------------
# kitty kitten API — imported only when running inside kitty.
# The scrollback is delivered via stdin when kitty launches this kitten with:
#   launch --type=overlay kitty +kitten search.py
# ---------------------------------------------------------------------------
try:
    from kittens.tui.handler import Handler
    from kittens.tui.loop import Loop
    from kittens.tui.operations import (
        clear_screen,
        cursor,
        set_cursor_visible,
        styled,
        move_cursor_to,
    )

    _HAVE_TUI = True
except ImportError:
    _HAVE_TUI = False

# ===== CONSTANTS =====

MAX_PATTERN_LENGTH: int = 200
SEARCH_BAR_HEIGHT: int = 1

# Raw ANSI helpers (used when TUI ops are unavailable and in bar rendering)
_ESC = "\x1b"
_CSI = _ESC + "["
_RESET = _CSI + "m"
_BG_BAR = _CSI + "48;5;236m"
_FG_BAR = _CSI + "38;5;255m"
_FG_MATCH = _CSI + "48;5;58;38;5;255m"  # olive bg, white fg
_FG_CUR = _CSI + "48;5;220;38;5;16m"  # yellow bg, black fg
_FG_NOMATCH = _CSI + "38;5;196m"  # red fg
_FG_BOLD = _CSI + "1m"
_HIDE_CURSOR = _CSI + "?25l"
_SHOW_CURSOR = _CSI + "?25h"
_SAVE_POS = _ESC + "7"
_REST_POS = _ESC + "8"


# ===== ENUMS =====


class SearchMode(Enum):
    LITERAL = auto()
    REGEX = auto()


class CaseSensitivity(Enum):
    INSENSITIVE = auto()
    SENSITIVE = auto()


# ===== STATE =====


@dataclass
class SearchState:
    """All mutable search state in one place."""

    pattern: str = ""
    mode: SearchMode = SearchMode.LITERAL
    case: CaseSensitivity = CaseSensitivity.INSENSITIVE
    original_scroll_line: int = 0
    current_match_index: int = -1
    match_lines: List[int] = field(default_factory=list)

    @property
    def total_matches(self) -> int:
        return len(self.match_lines)

    @property
    def current_line(self) -> Optional[int]:
        if self.current_match_index < 0 or not self.match_lines:
            return None
        return self.match_lines[self.current_match_index]

    @property
    def counter_text(self) -> str:
        if not self.match_lines:
            return "[0/0]"
        return f"[{self.current_match_index + 1}/{self.total_matches}]"

    @property
    def mode_flag(self) -> str:
        return "R" if self.mode is SearchMode.REGEX else "L"

    @property
    def case_flag(self) -> str:
        return "C" if self.case is CaseSensitivity.SENSITIVE else "I"


# ===== SEARCH ENGINE =====


class SearchEngine:
    """Pure-Python incremental search with result caching."""

    def __init__(self, lines: List[str]) -> None:
        self.lines = lines
        self._cache_key: str = ""
        self._cache_flags: int = -1
        self._cache_result: List[int] = []

    def search(
        self,
        pattern: str,
        mode: SearchMode = SearchMode.LITERAL,
        case: CaseSensitivity = CaseSensitivity.INSENSITIVE,
    ) -> List[int]:
        if not pattern:
            self._cache_key = ""
            return []
        flags = re.MULTILINE | (
            re.IGNORECASE if case is CaseSensitivity.INSENSITIVE else 0
        )
        key = pattern + "\x00" + mode.name
        if key == self._cache_key and flags == self._cache_flags:
            return list(self._cache_result)
        compiled = self._compile(pattern, mode, flags)
        if compiled is None:
            return []
        result = [i for i, ln in enumerate(self.lines) if compiled.search(ln)]
        self._cache_key = key
        self._cache_flags = flags
        self._cache_result = result
        return list(result)

    def find_next(self, match_lines: List[int], idx: int, wrap: bool = True) -> int:
        if not match_lines:
            return idx
        nxt = idx + 1
        if nxt >= len(match_lines):
            nxt = 0 if wrap else len(match_lines) - 1
        return nxt

    def find_previous(self, match_lines: List[int], idx: int, wrap: bool = True) -> int:
        if not match_lines:
            return idx
        prv = idx - 1
        if prv < 0:
            prv = len(match_lines) - 1 if wrap else 0
        return prv

    def get_match_spans(
        self, line_num: int, pattern: str, mode: SearchMode, case: CaseSensitivity
    ) -> List[Tuple[int, int]]:
        if line_num < 0 or line_num >= len(self.lines):
            return []
        flags = re.MULTILINE | (
            re.IGNORECASE if case is CaseSensitivity.INSENSITIVE else 0
        )
        compiled = self._compile(pattern, mode, flags)
        if compiled is None:
            return []
        return [(m.start(), m.end()) for m in compiled.finditer(self.lines[line_num])]

    @staticmethod
    def _compile(
        pattern: str, mode: SearchMode, flags: int
    ) -> Optional[re.Pattern[str]]:
        if mode is SearchMode.LITERAL:
            pattern = re.escape(pattern)
        try:
            return re.compile(pattern, flags)
        except re.error:
            return None

    def invalidate(self) -> None:
        self._cache_key = ""

    def _invalidate_cache(self) -> None:
        """Compatibility alias used by benchmark.py."""

        self.invalidate()


# ===== RAW-TTY UI =====
# We implement the UI directly with ANSI escapes and raw-mode stdin.
# This works reliably without depending on kittens.tui (which has a
# different API across kitty versions).


def _write(*parts: str) -> None:
    sys.stdout.write("".join(parts))
    sys.stdout.flush()


def _move(row: int, col: int) -> None:
    _write(f"{_CSI}{row};{col}H")


def _get_terminal_size() -> Tuple[int, int]:
    try:
        sz = shutil.get_terminal_size()
        return sz.columns, sz.lines
    except OSError:
        return 80, 24


def _byte_to_key(ch: str) -> str:
    """Map a raw byte from stdin to a logical key name.

    This keeps the test suite and keyboard handling compatibility with the
    earlier implementation that exposed this helper.
    """

    mapping = {
        "\x01": "ctrl+a",
        "\x05": "ctrl+e",
        "\x09": "tab",
        "\x0a": "enter",
        "\x0d": "enter",
        "\x0e": "ctrl+n",
        "\x10": "ctrl+p",
        "\x15": "ctrl+u",
        "\x17": "ctrl+w",
        "\x1b": "esc",
        "\x08": "backspace",
        "\x7f": "backspace",
    }
    return mapping.get(ch, ch)


class SearchUI:
    """Compatibility facade for the original SearchUI test surface."""

    def __init__(self, screen_cols: int, screen_rows: int) -> None:
        self.screen_cols = screen_cols
        self.screen_rows = screen_rows

    def render_search_bar(self, state: SearchState) -> None:
        """Render just the search bar into stdout for tests or fallback use."""

        cols = max(1, self.screen_cols)
        prompt = "/> "
        suffix = f"{state.counter_text} {state.mode_flag} {state.case_flag}"
        suffix_width = len(suffix)
        text_width = max(0, cols - len(prompt) - suffix_width)

        pattern = state.pattern
        if len(pattern) > text_width:
            if text_width <= 1:
                pattern = pattern[:text_width]
            else:
                pattern = "…" + pattern[-(text_width - 1) :]

        if state.pattern and not state.match_lines:
            suffix = _FG_NOMATCH + suffix + _FG_BAR

        left = prompt + pattern
        pad = max(1, cols - len(left) - len(state.counter_text) - 4)
        if len(left) + pad + suffix_width > cols:
            pad = max(1, cols - len(left) - suffix_width)
        if pad < 1:
            left = left[: max(0, cols - suffix_width - 1)]
            pad = 1

        _write(_BG_BAR + _FG_BAR + left + " " * pad + suffix + _RESET)

    def clear_search_bar(self) -> None:
        """Compatibility no-op used by tests when mocking cleanup."""

        return None


class SearchScreen:
    """Renders the full-screen search UI over the scrollback text."""

    def __init__(self, lines: List[str], cols: int, rows: int) -> None:
        self.lines = lines
        self.cols = cols
        self.rows = rows
        # Viewport: which scrollback line is at the top of the display area.
        self.viewport_top = max(0, len(lines) - (rows - SEARCH_BAR_HEIGHT))

    def refresh_size(self) -> None:
        """Refresh cached terminal dimensions after a resize."""

        self.cols, self.rows = _get_terminal_size()
        display_rows = max(1, self.rows - SEARCH_BAR_HEIGHT)
        max_top = max(0, len(self.lines) - display_rows)
        self.viewport_top = max(0, min(self.viewport_top, max_top))

    # ------------------------------------------------------------------ #
    # Full repaint                                                         #
    # ------------------------------------------------------------------ #

    def repaint(self, state: SearchState) -> None:
        """Redraw text area + search bar."""
        self.refresh_size()
        _write(_CSI + "H" + _CSI + "2J")
        _write(_HIDE_CURSOR)
        self._draw_text(state)
        self._draw_bar(state)
        _write(_SHOW_CURSOR)

    def _draw_text(self, state: SearchState) -> None:
        """Draw the visible portion of the scrollback with match highlights."""
        display_rows = self.rows - SEARCH_BAR_HEIGHT
        match_set = set(state.match_lines)
        current_ln = state.current_line

        for screen_row in range(display_rows):
            buf_line = self.viewport_top + screen_row
            _move(screen_row + 1, 1)
            _write(_RESET)

            if buf_line >= len(self.lines):
                _write(" " * self.cols)
                continue

            text = self.lines[buf_line]

            if buf_line == current_ln and state.pattern:
                # Render with per-character highlight for the *current* match.
                self._render_highlighted(text, buf_line, state, current=True)
            elif buf_line in match_set and state.pattern:
                self._render_highlighted(text, buf_line, state, current=False)
            else:
                display = text[: self.cols].ljust(self.cols)
                _write(display)

        _write(_RESET)

    def _render_highlighted(
        self, text: str, line_num: int, state: SearchState, *, current: bool
    ) -> None:
        """Write a line with match spans coloured in."""
        spans = []
        if state.pattern:
            spans = SearchEngine([text]).get_match_spans(
                0, state.pattern, state.mode, state.case
            )

        colour = _FG_CUR if current else _FG_MATCH
        pos = 0
        output: List[str] = []
        for start, end in spans:
            if start > pos:
                output.append(_RESET + text[pos:start])
            output.append(colour + text[start:end] + _RESET)
            pos = end
        if pos < len(text):
            output.append(_RESET + text[pos:])

        line_text = "".join(output)
        # Naive visible-length estimation (ignores ANSI sequences for padding).
        visible = re.sub(r"\x1b\[[^m]*m", "", line_text)
        pad = max(0, self.cols - len(visible))
        _write(line_text + " " * pad)

    def _draw_bar(self, state: SearchState) -> None:
        """Draw the search bar at the bottom row."""
        _move(self.rows, 1)
        _write(_BG_BAR + _FG_BAR)

        prompt = "/ "
        suffix = f"{state.counter_text} {state.mode_flag} {state.case_flag}"
        suffix_width = len(suffix)
        text_width = max(0, self.cols - len(prompt) - suffix_width)

        pat = state.pattern
        if len(pat) > text_width:
            if text_width <= 1:
                pat = pat[:text_width]
            else:
                pat = "…" + pat[-(text_width - 1) :]

        if state.pattern and not state.match_lines:
            suffix = _FG_NOMATCH + suffix + _FG_BAR

        left = prompt + pat
        pad = max(1, self.cols - len(left) - len(state.counter_text) - 4)
        if len(left) + pad + suffix_width > self.cols:
            pad = max(1, self.cols - len(left) - suffix_width)
        if pad < 1:
            left = left[: max(0, self.cols - suffix_width - 1)]
            pad = 1

        _write(left + " " * pad + suffix + _RESET)

    # ------------------------------------------------------------------ #
    # Viewport management                                                  #
    # ------------------------------------------------------------------ #

    def scroll_to(self, target_line: int) -> None:
        """Adjust viewport so *target_line* is visible (centred if possible)."""
        display_rows = self.rows - SEARCH_BAR_HEIGHT
        # Try to centre the target.
        desired_top = target_line - display_rows // 2
        max_top = max(0, len(self.lines) - display_rows)
        self.viewport_top = max(0, min(desired_top, max_top))

    def scroll_delta(self, delta: int) -> None:
        """Scroll the viewport by *delta* lines (positive = down)."""
        display_rows = self.rows - SEARCH_BAR_HEIGHT
        max_top = max(0, len(self.lines) - display_rows)
        self.viewport_top = max(0, min(self.viewport_top + delta, max_top))


# ===== MAIN KITTEN LOGIC =====


class SearchKitten:
    """Drives the search UI, reads keys, manages state."""

    def __init__(
        self,
        lines: Optional[List[str]] = None,
        *,
        screen_cols: Optional[int] = None,
        screen_rows: Optional[int] = None,
    ) -> None:
        self.lines = list(lines or [])
        self.state = SearchState()
        self.engine = SearchEngine(self.lines)
        if screen_cols is None or screen_rows is None:
            self.cols, self.rows = _get_terminal_size()
        else:
            self.cols, self.rows = screen_cols, screen_rows
        self.screen = SearchScreen(self.lines, self.cols, self.rows)
        self.ui = SearchUI(self.cols, self.rows)
        self.scroller = self.screen
        self.accessor = self
        self.running = True
        self._cursor = len(self.lines)  # scroll remembers: which line was focused

    @property
    def lines(self) -> List[str]:
        """Current scrollback lines used by the search."""

        return self._lines

    @lines.setter
    def lines(self, value: List[str]) -> None:
        self._lines = value
        if hasattr(self, "screen"):
            self.screen.lines = value
        if hasattr(self, "engine"):
            self.engine.lines = value

    def restore_scroll(self, target_line: int) -> None:
        """Compatibility hook used by tests; restore scroll to a line."""

        self.screen.scroll_to(target_line)

    # ------------------------------------------------------------------ #
    # Event loop                                                           #
    # ------------------------------------------------------------------ #

    def run(self) -> Optional[int]:
        """Run the interactive search loop.

        Returns:
            The scrollback line number of the accepted match, or None if
            the user cancelled.
        """
        # Save terminal state.
        fd = sys.stdin.fileno()
        old_attrs = termios.tcgetattr(fd)
        old_screen = os.environ.get("TERM", "")

        # Alternate screen + hide cursor.
        _write(_ESC + "[?1049h")  # enter alternate screen
        _write(_HIDE_CURSOR)
        _write(_CSI + "2J")  # clear

        tty.setraw(fd)
        try:
            self.screen.repaint(self.state)
            while self.running:
                ch = _read_key(fd)
                self._handle(ch)
                if self.running:
                    self.screen.repaint(self.state)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_attrs)
            _write(_RESET)
            _write(_SHOW_CURSOR)
            _write(_ESC + "[?1049l")  # leave alternate screen

        return self.state.current_line

    # ------------------------------------------------------------------ #
    # Key dispatch                                                         #
    # ------------------------------------------------------------------ #

    def _handle(self, key: str) -> None:
        k = _byte_to_key(key)
        if k == "esc":
            self._cancel()
        elif k in ("enter",):
            self._confirm()
        elif k == "ctrl+n":
            self._nav_next()  # ctrl+n
        elif k == "ctrl+p":
            self._nav_prev()  # ctrl+p
        elif k in ("tab",):
            self._cycle_mode()
        elif k in ("ctrl+i",):
            self._toggle_case()
        elif k in ("backspace", "\x7f", "\x08"):
            self._backspace()
        elif k in ("ctrl+w", "\x17"):
            self._delete_word()
        elif k in ("ctrl+u", "\x15"):
            self._clear_pattern()
        elif k in ("ctrl+a", "\x01"):
            self._cursor_to_start()
        elif k in ("ctrl+e", "\x05"):
            self._cursor_to_end()
        # Page-up / page-down via arrow-ish sequences
        elif k == "pgup":
            self.screen.scroll_delta(-(self.rows - 2))
        elif k == "pgdn":
            self.screen.scroll_delta((self.rows - 2))
        elif k == "up":
            self.screen.scroll_delta(-3)
        elif k == "down":
            self.screen.scroll_delta(3)
        elif len(k) == 1 and k.isprintable():
            self._insert(k)

    # ------------------------------------------------------------------ #
    # Editing                                                              #
    # ------------------------------------------------------------------ #

    def _insert(self, ch: str) -> None:
        if len(self.state.pattern) >= MAX_PATTERN_LENGTH:
            return
        self.state.pattern += ch
        self._run_search(reset=True)

    def _backspace(self) -> None:
        if self.state.pattern:
            self.state.pattern = self.state.pattern[:-1]
            self._run_search(reset=True)

    def _delete_word(self) -> None:
        p = self.state.pattern.rstrip()
        idx = p.rfind(" ")
        self.state.pattern = p[: idx + 1] if idx >= 0 else ""
        self._run_search(reset=True)

    def _clear_pattern(self) -> None:
        self.state.pattern = ""
        self._run_search(reset=True)

    def _cursor_to_start(self) -> None:
        pass  # cursor tracking removed for simplicity (pattern appends to end)

    def _cursor_to_end(self) -> None:
        pass

    def _cycle_mode(self) -> None:
        self.state.mode = (
            SearchMode.REGEX
            if self.state.mode is SearchMode.LITERAL
            else SearchMode.LITERAL
        )
        self.engine.invalidate()
        self._run_search(reset=False)

    def _toggle_case(self) -> None:
        self.state.case = (
            CaseSensitivity.SENSITIVE
            if self.state.case is CaseSensitivity.INSENSITIVE
            else CaseSensitivity.INSENSITIVE
        )
        self.engine.invalidate()
        self._run_search(reset=False)

    # ------------------------------------------------------------------ #
    # Navigation                                                           #
    # ------------------------------------------------------------------ #

    def _nav_next(self) -> None:
        idx = self.engine.find_next(
            self.state.match_lines, self.state.current_match_index
        )
        self.state.current_match_index = idx
        self._scroll_to_current()

    def _nav_prev(self) -> None:
        idx = self.engine.find_previous(
            self.state.match_lines, self.state.current_match_index
        )
        self.state.current_match_index = idx
        self._scroll_to_current()

    def _scroll_to_current(self) -> None:
        line = self.state.current_line
        if line is not None:
            self.screen.refresh_size()
            self.screen.scroll_to(line)

    # ------------------------------------------------------------------ #
    # Lifecycle                                                            #
    # ------------------------------------------------------------------ #

    def _run_search(self, *, reset: bool) -> None:
        prev = self.state.current_line
        self.state.match_lines = self.engine.search(
            self.state.pattern, self.state.mode, self.state.case
        )
        if not self.state.match_lines:
            self.state.current_match_index = -1
            return
        if reset:
            self.state.current_match_index = 0
            self._scroll_to_current()
        else:
            if prev is not None and prev in self.state.match_lines:
                self.state.current_match_index = self.state.match_lines.index(prev)
            else:
                self.state.current_match_index = 0
                self._scroll_to_current()

    def _cancel(self) -> None:
        self.accessor.restore_scroll(self.state.original_scroll_line)
        self.state.current_match_index = -1
        self.running = False

    def handle_key(self, key: str) -> None:
        """Public key handler retained for test compatibility."""

        self._handle(key)

    def _confirm(self) -> None:
        self.running = False


# ===== KEY READER =====


def _read_key(fd: int) -> str:
    """Read one logical keypress from *fd* (raw mode assumed).

    Handles multi-byte escape sequences for arrows and page keys.
    """
    ch = os.read(fd, 1).decode("utf-8", errors="replace")
    if ch == "\x1b":
        # Try to read the rest of an escape sequence (non-blocking peek).
        import select

        ready, _, _ = select.select([fd], [], [], 0.05)
        if not ready:
            return "esc"
        rest = os.read(fd, 8).decode("utf-8", errors="replace")
        seq = ch + rest
        _SEQ = {
            "\x1b[A": "up",
            "\x1b[B": "down",
            "\x1b[5~": "pgup",
            "\x1b[6~": "pgdn",
            "\x1bOA": "up",
            "\x1bOB": "down",
        }
        return _SEQ.get(seq, seq)
    if ch == "\t":
        return "tab"
    if ch in ("\r", "\n"):
        return "enter"
    return ch


# ===== KITTY ENTRY POINTS =====


def main(args: List[str]) -> str:
    """Kitten main — reads scrollback from stdin, runs UI, returns result.

    Kitty pipes the scrollback buffer into stdin before calling this function
    when the kitten is launched as an overlay with ``--stdin-source=@screen_scrollback``.
    """
    # Read scrollback from stdin (kitty pipes it in).
    raw = sys.stdin.read()
    lines = raw.splitlines()

    if not lines:
        # Nothing to search — print a message and exit immediately.
        print("No scrollback to search.")
        return ""

    # Reopen stdin from the terminal so we can read keypresses.
    try:
        tty_fd = open("/dev/tty", "r+b", buffering=0)
        old_stdin = sys.stdin
        sys.stdin = open("/dev/tty", "r")
    except OSError:
        print("Cannot open /dev/tty.")
        return ""

    kitten = SearchKitten(lines)
    # Redirect stdout to the tty for rendering.
    old_stdout = sys.stdout
    sys.stdout = open("/dev/tty", "w")

    try:
        result_line = kitten.run()
    finally:
        sys.stdout.flush()
        sys.stdout = old_stdout
        sys.stdin = old_stdin
        tty_fd.close()

    if result_line is None:
        return ""
    return str(result_line)


def handle_result(
    args: List[str],
    result: str,
    target_window_id: int,
    boss: object,
) -> None:
    """Called by kitty after main() exits.

    If the user accepted a match we scroll the *real* window to that line.
    """
    if not result:
        return
    try:
        line_num = int(result)
    except ValueError:
        return

    # Ask kitty to scroll the target window.
    try:
        w = boss.window_id_map.get(target_window_id)  # type: ignore[attr-defined]
        if w is not None:
            w.screen.scroll_to_prompt(-1)
            # Scroll by setting scrolled_by relative to bottom of history.
            total = w.screen.historycells + w.screen.lines
            from_bottom = max(0, total - line_num - 1)
            w.screen.scroll_to(from_bottom)
    except Exception:
        pass
