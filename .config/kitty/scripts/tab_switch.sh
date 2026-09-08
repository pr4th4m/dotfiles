#!/bin/zsh
# ~/.config/kitty/scripts/tab_switch.sh
set -euo pipefail

SOCKET="${KITTY_LISTEN_ON:-}"

# Swap to `jaq` here if you have it installed (brew install jaq) — it's a
# Rust reimplementation of jq's CLI/filter language with much faster startup,
# which matters more than raw throughput for a script that runs this often.
JQ_BIN=${JQ_BIN:-jq}

kitty_cmd() {
    if [[ -n "$SOCKET" ]]; then
        kitty @ --to "$SOCKET" "$@"
    else
        kitty @ "$@"
    fi
}

rows=$(kitty_cmd ls | "$JQ_BIN" -r '
  .[] as $osw
  | ($osw.tabs[] | select(.is_focused) | .id) as $current
  | ($osw.tabs | map(.id)) as $ids
  | (($osw.active_tab_history // []) | reverse) as $hist_desc
  | ($hist_desc - [$current]) as $hist_no_current
  | ($ids - ([$current] + $hist_no_current)) as $remaining
  | ([$current] + $hist_no_current + $remaining) as $order
  | [ $order[] as $id | ($osw.tabs[] | select(.id == $id) | select(.is_focused | not)) ]
  | to_entries[]
  | "\(.key + 1)\t\(.value.id)\t\(.value.title)"
')

[[ -n "$rows" ]] || exit 0

chosen=$(printf '%s\n' "$rows" \
  | fzf --prompt="tab> " \
        --height=100% \
        --layout=reverse \
        --border \
        --delimiter=$'\t' \
        --with-nth=1,3)

[[ -n "$chosen" ]] || exit 0

chosen_id=$(printf '%s' "$chosen" | cut -f2)
kitty_cmd focus-tab --match "id:$chosen_id"
