#!/bin/zsh

selected=$(ls -Gt ~/scripts/*.sh 2>/dev/null | xargs -n1 basename | fzf --prompt="Clusters> ")

if [ -n "$selected" ]; then
  kitty @ launch --type=tab zsh -i -c "~/scripts/$selected"
fi
