#!/bin/zsh
# ~/.config/kitty/scripts/session.sh
# fzf based kitty session manager. Run as an overlay (see kitty.conf).
#
#   enter   switch to session (creates it when the query matches nothing)
#   alt-n   new session (name = query, or prompt)
#   alt-s   save current session as... (prompt, defaults to current name)
#   alt-x   close selected session (closes its windows, keeps the file)
#   alt-d   delete selected session file (closes it first if open)
#   alt-r   rename selected session (file + open windows)
#   alt-e   edit selected session file in $EDITOR
#
# session.sh --new [NAME]   create a new session directly (no picker)
#
# Startup is kept fast: fzf opens immediately with the session files, the
# remote-control query (open/current markers) is loaded asynchronously.
set -uo pipefail

SESSION_DIR="${KITTY_SESSION_DIR:-$HOME/.config/kitty/sessions}"
EXT="kitty-session"
SELF=${0:A}
if (( $+commands[jaq] )); then JQ_BIN=${JQ_BIN:-jaq}; else JQ_BIN=${JQ_BIN:-jq}; fi
[[ -d "$SESSION_DIR" ]] || mkdir -p "$SESSION_DIR"

kitty_cmd() {
    local -a rc
    if (( $+commands[kitten] )); then rc=(kitten @); else rc=(kitty @); fi
    [[ -n "${KITTY_LISTEN_ON:-}" ]] && rc+=(--to "$KITTY_LISTEN_ON")
    "${rc[@]}" "$@"
}

# Prints "<target window id>\t<current session>" then one open session per line.
# Target = the window this overlay sits on top of, so "." resolves to its session.
query_state() {
    kitty_cmd ls 2>/dev/null | "$JQ_BIN" -r '
      ([ .[] | select(.is_focused) | .tabs[] | select(.is_focused) | .windows[] ]
        | (map(select(.is_self | not)) | if length > 0 then . else null end) // .
        | sort_by(.last_focused_at) | .[-1]
        | "\(.id // "")\t\(.session_name // "")"),
      ([ .[].tabs[].windows[] | .session_name // "" | select(. != "") ] | unique | .[])'
}

file_names() {
    local f
    for f in "$SESSION_DIR"/*.$EXT(N); do print -r -- ${${f:t}%.$EXT}; done
}

# rows <current> <open sessions...>
rows() {
    local current=$1; shift
    local -A open seen
    local name mark
    for name in "$@"; do open[$name]=1; done
    for name in $(file_names) "$@"; do
        [[ -n "$name" && -z "${seen[$name]:-}" ]] || continue
        seen[$name]=1
        mark=" "
        [[ -n "${open[$name]:-}" ]] && mark="●"
        [[ "$name" == "$current" ]] && mark="★"
        print -r -- "$mark"$'\t'"$name"
    done | sort -t$'\t' -k2
}

# Async helpers invoked by fzf binds
if [[ "${1:-}" == --rows ]]; then
    lines=("${(@f)$(query_state)}")
    print -rl -- "${lines[@]}" > "$2.tmp" && mv -f "$2.tmp" "$2"
    t=${lines[1]:-}
    rows "${t#*$'\t'}" "${(@)lines[2,-1]}"
    exit 0
fi

STATE=$(mktemp -t kitty-session) || exit 1
rm -f "$STATE"
trap 'rm -f "$STATE" "$STATE.tmp"' EXIT

if [[ "${1:-}" == --new ]]; then
    # Explicit "new session" entry point (kitty.conf), skips the picker
    query=${2:-} key=alt-n selected=""
else
out=$(rows "" | fzf \
    --prompt="session> " \
    --layout=reverse \
    --delimiter=$'\t' \
    --print-query \
    --header="enter switch/create · M-n new · M-s save as · M-x close · M-d delete · M-r rename · M-e edit" \
    --expect=alt-n,alt-s,alt-x,alt-d,alt-r,alt-e \
    --bind="start:reload($SELF --rows $STATE)")
[[ $? -le 1 ]] || exit 0

lines=("${(@f)out}")
query=${lines[1]:-}
key=${lines[2]:-}
selected=${${lines[3]:-}#*$'\t'}
fi

# State from the async query, or query now if fzf was closed before it finished
[[ -s "$STATE" ]] || query_state > "$STATE"
st=("${(@f)$(<$STATE)}")
TARGET_ID=${st[1]%%$'\t'*}
CURRENT=${st[1]#*$'\t'}
active=("${(@)st[2,-1]}")

pause() { print -P "%F{8}$1%f"; read -k1 -s; }
action() {
    if [[ -n "$TARGET_ID" ]]; then
        kitty_cmd action --match "id:$TARGET_ID" "$@"
    else
        kitty_cmd action "$@"
    fi
}
is_open() { (( ${active[(Ie)$1]} )); }
path_for() { print -r -- "$SESSION_DIR/$1.$EXT"; }
sanitize() { local n="${1// /-}"; print -r -- "${n//\//-}"; }

prompt_name() {
    local name="${2:-}"
    vared -p "$1" name
    sanitize "$name"
}

new_session() {
    local name=$(sanitize "$1")
    [[ -n "$name" ]] || name=$(prompt_name "new session name: ")
    [[ -n "$name" ]] || return
    local file=$(path_for "$name")
    [[ -e "$file" ]] || printf 'layout splits\ncd ~\nlaunch\n' > "$file"
    action goto_session "$file"
}

switch_session() {
    local file=$(path_for "$1")
    if [[ -e "$file" ]]; then
        action goto_session "$file"
    else
        action goto_session "$1"
    fi
}

save_session() {
    local name=$(prompt_name "save session as: " "${CURRENT:-default}")
    [[ -n "$name" ]] || return
    local file=$(path_for "$name")
    if [[ -e "$file" && "$name" != "$CURRENT" ]]; then
        read -q "?$name exists, overwrite? [y/N] " || return
        print
    fi
    local match='session:.'
    [[ -n "$CURRENT" ]] || match='session:^$'
    if action save_as_session --save-only --use-foreground-process "--match=$match" "$file"; then
        [[ -n "$CURRENT" ]] || pause "saved unsessioned windows to $file (press any key)"
    else
        pause "save failed (press any key)"
    fi
}

close_session() {
    if is_open "$1"; then
        action close_session "$1"
    else
        pause "$1 is not open (press any key)"
    fi
}

delete_session() {
    local name="$1" file=$(path_for "$1")
    print -P "%F{red}Delete $file permanently?%f"
    read -q "?[y/N] " || return
    print
    is_open "$name" && action close_session "$name"
    rm -f -- "$file"
}

rename_session() {
    local old="$1" file=$(path_for "$1")
    local new=$(prompt_name "rename $old to: " "$old")
    [[ -n "$new" && "$new" != "$old" ]] || return
    local new_file=$(path_for "$new")
    if [[ -e "$new_file" ]] || is_open "$new"; then
        pause "$new already exists (press any key)"
        return
    fi
    [[ -e "$file" ]] && mv -- "$file" "$new_file"
    if is_open "$old"; then
        local p=""
        [[ -e "$new_file" ]] && p="$new_file"
        action kitten session_rename.py "$old" "$new" ${p:+"$p"}
    fi
}

case "$key" in
    alt-n) new_session "$query" ;;
    alt-s) save_session ;;
    alt-x) [[ -n "$selected" ]] && close_session "$selected" ;;
    alt-d) [[ -n "$selected" ]] && delete_session "$selected" ;;
    alt-r) [[ -n "$selected" ]] && rename_session "$selected" ;;
    alt-e) [[ -n "$selected" ]] && ${EDITOR:-nvim} "$(path_for "$selected")" ;;
    *)
        if [[ -n "$selected" ]]; then
            switch_session "$selected"
        elif [[ -n "$query" ]]; then
            new_session "$query"
        fi
        ;;
esac
