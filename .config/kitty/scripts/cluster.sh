#!/bin/zsh

selected=$(fd -e sh -d 1 . ~/scripts 2>/dev/null | awk -F'/' '{
    f=$NF
    if (f ~ /^oci/) print "\033[31m" f "\033[0m"
    else if (f ~ /^ope/) print "\033[34m" f "\033[0m"
    else print f
}' | fzf --cycle --ansi --prompt="Clusters> ")

# strip ansi codes — pure zsh, no external process
selected=${selected//$'\e'\[*([0-9;])m/}

if [[ -n "$selected" ]]; then
  kitty @ launch --type=tab zsh -i -c "~/scripts/$selected"
fi
