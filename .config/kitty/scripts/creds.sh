#!/bin/zsh

CREDS_FILE="$HOME/.creds.txt.age"
IDENTITY="$HOME/.age/key.txt"

creds=$(age -d -i "$IDENTITY" "$CREDS_FILE")
selected=$(echo "$creds" | cut -d: -f1 | fzf --prompt="Credentials> ")

if [[ -n "$selected" ]]; then
  password=$(echo "$creds" | awk -F: -v user="$selected" '$1 == user { $1=""; sub(/^:/,""); print }')
  echo -n "$password" | pbcopy
  kitty @ close-window
fi
