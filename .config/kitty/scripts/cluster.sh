#!/bin/zsh

selected=$(ls -Gu ~/scripts/*.sh 2>/dev/null | xargs -n1 basename | awk '{
    if ($0 ~ /^oci/) print "\033[31m" $0 "\033[0m"
    else if ($0 ~ /^ope/) print "\033[34m" $0 "\033[0m"
    else print $0
}' | fzf --cycle --ansi --prompt="Clusters> ")

# strip color codes from selected before using
selected=$(echo "$selected" | sed 's/\033\[[0-9;]*m//g')

if [ -n "$selected" ]; then
  kitty @ launch --type=tab zsh -i -c "~/scripts/$selected"
fi
