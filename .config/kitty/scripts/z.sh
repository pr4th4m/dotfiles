#!/bin/zsh

selected=$(zoxide query -i)

if [ -n "$selected" ]; then
  kitty @ launch --type=tab --cwd "$selected"
fi
