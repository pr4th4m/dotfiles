import os
from typing import Any

from kitty.boss import Boss
from kitty.window import Window

SESSIONS_DIR = os.path.expanduser(
    os.environ.get("KITTY_SESSION_DIR") or "~/.config/kitty/sessions"
)


def on_quit(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    """Save all loaded sessions to SESSIONS_DIR when kitty quits."""
    if not data.get("confirmed"):
        return
    os.makedirs(SESSIONS_DIR, exist_ok=True)
    for name in list(boss.all_loaded_session_names):
        safe_name = name.replace("/", "-")
        boss.save_as_session(
            "--save-only",
            "--use-foreground-process",
            "--base-dir",
            SESSIONS_DIR,
            f"--match=session:{name}",
            f"{safe_name}.kitty-session",
        )
