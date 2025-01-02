# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set locale
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

######## Configuration ############
# vi key bindings
bindkey -v
export KEYTIMEOUT=20
bindkey -M viins 'jj' vi-cmd-mode
# vi mode visual select text color
zle_highlight=(region:'bg=#364A82,fg=#c0caf5')
# https://github.com/kutsan/zsh-system-clipboard
ZSH_SYSTEM_CLIPBOARD_METHOD=pb

# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# case in-sensitive completion
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# useful alias
# https://hasseg.org/trash/
alias rm='trash -F'
alias rg='rg --hyperlink-format=kitty'
# alias ls='gls --color --group-directories-first --hyperlink=auto'
# alias ll='gls -lh --color --group-directories-first --hyperlink=auto'
alias ls='ls -Gt'
alias ll='ls -lthG'
# alias cat='bat -pp --theme base16'
alias cs='cht.sh'
alias ks='kitty @ send-text -m ' 

# make vim as default editor
export TERM=xterm-256color
export EDITOR=nvim
export VISUAL=nvim

# Let fzf use rg
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# export FZF_HIDDEN=--hidden && source ~/.zshrc
export FZF_DEFAULT_COMMAND="fd --type f --color=never --exclude .git --exclude node_modules $FZF_HIDDEN" 
export FZF_DEFAULT_OPTS='--layout=reverse --border'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--bind='enter:become:nvim {+} >/dev/tty' -m --height 90% --preview 'bat --theme Nord --plain --pager never --color always {} | head -500'"

# change default clt-c to ctrl-e
# export FZF_HIDDEN=--hidden && source ~/.zshrc
zle     -N     fzf-cd-widget
bindkey '^E'  fzf-cd-widget
export FZF_ALT_C_COMMAND="fd --type d --color=never --exclude .git --exclude node_modules $FZF_HIDDEN"
export FZF_ALT_C_OPTS="--height 90% --preview 'tree -C {} | head -500'"

##### Required paths ######

# Home brew installation path
export PATH="/usr/local/bin:$PATH"

export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# Rust package manager
export PATH="$HOME/.cargo/bin:$PATH"

# Set python path for user workspace
# NOTE: pip install <package> --user
export PATH="$HOME/Library/Python/3.12/bin:$PATH"

# set virtualenvwrapper path
# python3 -m venv .virtualenvs
# source .virtualenvs/bin/activate
# python3 -m pip install ipdb     

# Golang path
# export GOROOT=/usr/local/go
# export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin

export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# eval "$(starship init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# history-substring bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# history search highlighting color
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#d33682,fg=#a5b0c5,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=#dc322f,fg=#a5b0c5,bold'

# Load completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# Load sheldon
eval "$(sheldon source)"

# Postgres cli
export PATH=/usr/local/opt/libpq/bin:$PATH

# # garden cli
# export PATH=$PATH:$HOME/.garden/bin
# export PATH="/usr/local/sbin:$PATH"

# required by nvim image https://github.com/3rd/image.nvim
export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"

# k9s config directory
export K9S_CONFIG_DIR=$HOME/.config/k9s

# bw session key
export BW_SESSION="+nieQbVzdqxUqLN+ee0TSb5g5fCEBAjVItedCj+1gDzSzrszM1lpEpVa7IrCLONJ6JLh2CILZV9ss1/TrrAyng=="


## Useful zsh functions
# keepassxc fzf integration
keepass_fzf() {
  local db_path=/Users/prathameshnevagi/Library/CloudStorage/OneDrive-QuickHealTechnologiesLtd/SecretStore/QHSecretStore.kdbx
  local keyfile_path=/Users/prathameshnevagi/Library/CloudStorage/OneDrive-QuickHealTechnologiesLtd/SecretStore/qhkeyfile.keyx

  local entry
  entry=$( keepassxc-cli ls $db_path -f -R --no-password -k $keyfile_path | fzf --prompt="KeepassXC> " --height "40%" )

  if [ -n "$entry" ]; then
    # Copy the selected entry's password to the clipboard
    keepassxc-cli clip "$db_path" "$entry" 0 -q --no-password --key-file "$keyfile_path"
  fi

  # Inform the user
  # echo "Password for '$entry' copied to clipboard."
}
zle -N keepass_fzf
bindkey '^G' keepass_fzf

# zoxide
eval "$(zoxide init --cmd cd zsh)"
zoxide_fzf() {
  # selected=$(zoxide query -l | fzf --prompt="Zoxide> " --preview="ls -la {}" --bind "ctrl-d:execute(zoxide remove {})+abort")
  selected=$(zoxide query -l | fzf --prompt="Zoxide> " --height "40%" --preview="ls -la {}")
  if [ -n "$selected" ]; then
    cd "$selected" || return
    # echo "Changed directory to: $selected"
  fi
}
zle -N zoxide_fzf
bindkey '^Y' zoxide_fzf

# clear screen and keep scroll buffer
# https://sw.kovidgoyal.net/kitty/conf/#shortcut-kitty.Reset-the-terminal
clear_screen() {
    builtin print -rn -- $'\r\e[0J\e[H\e[22J' >"$TTY"
    builtin zle .reset-prompt
    builtin zle -R
}
zle -N clear_screen
bindkey '^o' clear_screen

clear_screen_and_scrollback() {
    builtin print -rn -- $'\r\e[0J\e[H\e[3J' >"$TTY"
    builtin zle .reset-prompt
    builtin zle -R
}
zle -N clear_screen_and_scrollback
bindkey '^]' clear_screen_and_scrollback
