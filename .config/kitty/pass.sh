#!/bin/bash
# /usr/local/bin/pass ls
# read -p "Name: " entry
# /usr/local/bin/pass -c "$entry"

db_path=/Users/prathameshnevagi/Library/CloudStorage/OneDrive-QuickHealTechnologiesLtd/SecretStore/QHSecretStore.kdbx
keyfile_path=/Users/prathameshnevagi/Library/CloudStorage/OneDrive-QuickHealTechnologiesLtd/SecretStore/qhkeyfile.keyx

entry=$(/usr/local/bin/keepassxc-cli ls $db_path -f -R --no-password -k $keyfile_path | fzf --prompt="KeepassXC> " --height "40%" --layout=reverse --border)
if [ -n "$entry" ]; then
  /usr/local/bin/keepassxc-cli clip $db_path  "$entry" 0 -q --no-password --key-file $keyfile_path  
fi
