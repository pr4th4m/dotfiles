# #!/bin/zsh
#
# CREDS_FILE="$HOME/.creds.txt.age"
# IDENTITY="$HOME/.age/key.txt"
#
# creds=$(age -d -i "$IDENTITY" "$CREDS_FILE")
# selected=$(echo "$creds" | cut -d: -f1 | fzf --prompt="Credentials> ")
#
# if [[ -n "$selected" ]]; then
#   password=$(echo "$creds" | awk -F: -v user="$selected" '$1 == user { $1=""; sub(/^:/,""); print }')
#   echo -n "$password" | pbcopy
#   kitty @ close-window
# fi

#!/bin/zsh

CREDS_FILE="$HOME/.creds.txt.age"
IDENTITY="$HOME/.age/key.txt"

creds=$(age -d -i "$IDENTITY" "$CREDS_FILE")
selected=$(echo "$creds" | cut -d: -f1 | sk --prompt="Credentials> " --reverse --no-multi --tiebreak=score,index)

if [[ -n "$selected" ]]; then
  password=$(printf '%s\n' "$creds" | awk -F: -v user="$selected" '
    $1 == user {
      sub(/^[^:]*:/, "")            # strip "user:" prefix, keeping any colons in the password
      sub(/[[:space:]]+$/, "")      # trim trailing whitespace
      print
      exit
    }')
  printf '%s' "$password" | pbcopy
  kitty @ close-window
fi
