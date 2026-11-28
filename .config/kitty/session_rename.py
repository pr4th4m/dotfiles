"""Rename a kitty session in the running instance.

Usage (from kitty.conf or remote control):
    kitten @ action kitten session_rename.py OLD NEW [NEW_SESSION_FILE]

Renaming only the session file leaves already open windows/tabs tagged with
the old name, so this updates them (and kitty's session history) in place.
"""

from typing import Any

from kittens.tui.handler import result_handler


def main(args: list[str]) -> str:
    return ""


@result_handler(no_ui=True)
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Any) -> None:
    if len(args) < 3:
        return
    old, new = args[1], args[2]
    path = args[3] if len(args) > 3 else ""
    if not old or not new or old == new:
        return

    for tm in boss.all_tab_managers:
        if getattr(tm, "created_in_session_name", "") == old:
            tm.created_in_session_name = new
        for tab in tm:
            if tab.created_in_session_name == old:
                tab.created_in_session_name = new
    for w in boss.window_id_map.values():
        if w.created_in_session_name == old:
            w.created_in_session_name = new

    try:
        import kitty.session as s

        s.seen_session_paths.pop(old, None)
        if path:
            s.seen_session_paths[new] = path
        h = s.goto_session_history
        h[:] = [new if n == old else n for n in h]
    except Exception:
        pass

    for tm in boss.all_tab_managers:
        tm.mark_tab_bar_dirty()
