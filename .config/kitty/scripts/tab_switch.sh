#!/bin/zsh
# ~/.config/kitty/scripts/tab_switch.sh
set -euo pipefail

SOCKET="${KITTY_LISTEN_ON:-}"

kitty_cmd() {
    if [[ -n "$SOCKET" ]]; then
        kitty @ --to "$SOCKET" "$@"
    else
        kitty @ "$@"
    fi
}

rows=$(kitty_cmd ls | jq -r '
  .[] | .tabs | to_entries[] |
  "\(.key + 1) | \(.value.id) | \(.value.title)"
')

chosen=$(printf '%s\n' "$rows" \
  | fzf --prompt="tab> " \
        --height=100% \
        --layout=reverse \
        --border)

[[ -n "$chosen" ]] || exit 0

chosen_id=$(printf '%s' "$chosen" | awk -F' \\| ' '{print $2}')
kitty_cmd focus-tab --match "id:$chosen_id"
