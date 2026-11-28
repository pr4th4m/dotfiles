#!/bin/zsh

selected=$(zoxide query -i)

if [ -n "$selected" ]; then
  kitty @ launch --type=tab --add-to-session=. --cwd "$selected"
fi
