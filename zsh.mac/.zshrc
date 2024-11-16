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
# alias c='clear'
alias cs='cht.sh'
# function m() {
#     export CMAP=$@
#     # local cmd=$@
#     # tmux set-environment CMAP $cmd
# }
# # unable to use above function from terminal directly
# # create new function which is used in kitty config with CMAP
# function csb() {
#     printf '\n%.0s' {1..$LINES}
#     clear
# }

# clear screen and keep scroll buffer
# https://sw.kovidgoyal.net/kitty/conf/#shortcut-kitty.Reset-the-terminal
scroll-and-clear-screen() {
    printf '\n%.0s' {1..$LINES}
    zle clear-screen
}
zle -N scroll-and-clear-screen
bindkey '^l' scroll-and-clear-screen

# # for 256 color support
# if [ -n "$TMUX" ]; then
#     export TERM=screen-256color
# else
#     export TERM=xterm-256color
# fi
export TERM=xterm-256color

# make vim as default editor
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

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# required by nvim image https://github.com/3rd/image.nvim
export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"
