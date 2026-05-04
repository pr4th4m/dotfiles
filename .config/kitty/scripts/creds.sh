#!/bin/zsh

CREDS_FILE="$HOME/.creds.txt"

selected=$(awk -F: '{print $1}' "$CREDS_FILE" | fzf --prompt="Credentials> ")

if [ -n "$selected" ]; then
  password=$(awk -F: -v user="$selected" '$1 == user {print $2}' "$CREDS_FILE")
  echo -n "$password" | pbcopy
  kitty @ close-window
fi
