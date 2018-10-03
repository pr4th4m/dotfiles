#### zPlug - zsh plugin manager ####
source ~/.zplug/init.zsh

# Self update zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Command completions
zplug "zsh-users/zsh-completions"

# Syntax highlighting for commands
zplug "zsh-users/zsh-syntax-highlighting"

# Quickly search history
zplug "zsh-users/zsh-history-substring-search", defer:1

# Docker completion
zplug "felixr/docker-zsh-completion", defer:1

zplug load
#### zPlug ####

# git status on right prompt
setopt prompt_subst
source ~/git-prompt.sh
export RPROMPT=$'%F{blue}$(__git_ps1 "%s")'
export PROMPT='%F{green}%~ %b$%B%F{grey}%f%b '
export GIT_PS1_SHOWDIRTYSTATE=1

# history-substring bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
. $HOME/z.sh

# Set locale
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

######## Configuration ############
# vi key bindings
bindkey -v
export KEYTIMEOUT=20
bindkey -M viins 'jj' vi-cmd-mode

# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# case in-sensitive completion
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# useful alias
alias ls='ls -G'
alias ll='ls -lh'

# for 256 color support
if [ -n "$TMUX" ]; then
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi

# make vim as default editor
export EDITOR=nvim
export VISUAL=nvim

# Let fzf use rg
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

##### Required paths ######

# Home brew installation path
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"

# Rust package manager
export PATH="$HOME/.cargo/bin:$PATH"

# Set python path for user workspace
# NOTE: pip install <package> --user
export PATH="$HOME/Library/Python/2.7/bin:$PATH"
export PATH="$HOME/Library/Python/3.6/bin:$PATH"
export PATH="$HOME/Library/Python/3.7/bin:$PATH"

# set virtualenvwrapper path
export WORKON_HOME=$HOME/.virtualenvs
# TODO: virtualenvwrapper makes zsh very slow
# source $HOME/Library/Python/2.7/bin/virtualenvwrapper.sh

# Golang path
export GOROOT=/usr/local/go
export GOPATH=$HOME/goworkspace
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
