#!/bin/zsh

CREDS_FILE="$HOME/.creds.txt"

selected=$(awk -F: '{print $1}' "$CREDS_FILE" | fzf --prompt="Credentials> ")

if [ -n "$selected" ]; then
  password=$(awk -v user="$selected" 'BEGIN{FS=":"} $1 == user {
    sub(/^[^:]*:/, ""); print
  }' "$CREDS_FILE")
  echo -n "$password" | pbcopy
  kitty @ close-window
fi
