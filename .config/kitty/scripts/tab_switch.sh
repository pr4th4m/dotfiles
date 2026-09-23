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
  # Index tabs by their real position in the (kitty) tab list first — this
  # is the same order tab_bar.py renders (it physically reorders tabs to
  # match its sections), so idx here is exactly the number shown in the
  # vertical tab bar.
  | ($osw.tabs | to_entries | map({idx: (.key + 1), id: .value.id, title: .value.title, is_focused: .value.is_focused})) as $indexed
  | ($indexed[] | select(.is_focused) | .id) as $current
  | ($indexed | map(.id)) as $ids
  | (($osw.active_tab_history // []) | reverse) as $hist_desc
  | ($hist_desc - [$current]) as $hist_no_current
  | ($ids - ([$current] + $hist_no_current)) as $remaining
  | ([$current] + $hist_no_current + $remaining) as $order
  | [ $order[] as $id | ($indexed[] | select(.id == $id) | select(.is_focused | not)) ]
  | .[]
  | "\(.idx)\t\(.id)\t\(.title)"
')

[[ -n "$rows" ]] || exit 0

chosen=$(printf '%s\n' "$rows" \
  | fzf --prompt="tab> " \
        --layout=reverse \
        --delimiter=$'\t' \
        --with-nth=1,3)

[[ -n "$chosen" ]] || exit 0

chosen_id=$(printf '%s' "$chosen" | cut -f2)
kitty_cmd focus-tab --match "id:$chosen_id"
