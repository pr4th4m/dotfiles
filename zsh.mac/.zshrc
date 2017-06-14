#### zPlug - zsh plugin manager ####
source ~/.zplug/init.zsh

# Command completions
zplug "zsh-users/zsh-completions"

# Syntax highlighting for commands
zplug "zsh-users/zsh-syntax-highlighting"

# Quickly search history
zplug "zsh-users/zsh-history-substring-search", defer:1

zplug load
#### zPlug ####

# git status on right prompt
setopt prompt_subst
source ~/git-prompt.sh
export RPROMPT=$'%F{blue}$(__git_ps1 "%s")'
export PROMPT='%F{yellow}%~ %b$%B%F{grey}%f%b '
export GIT_PS1_SHOWDIRTYSTATE=1

# history-substring bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


######## Configuration ############

# vi key bindings
bindkey -v
export KEYTIMEOUT=1

# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# case in-sensitive completion
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# useful alias
alias ls='ls -G'
alias ll='ls -lh'
alias nvim='reattach-to-user-namespace -l nvim' # fix tmux/osx copy issue

# for 256 color support
if [ -n "$TMUX" ]; then
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi

# make vim as default editor
export EDITOR=nvim
export VISUAL=nvim


##### Required paths ######

# Home brew installation path
export PATH="/usr/local/bin:$PATH"

# set virtualenvwrapper path
export WORKON_HOME=$HOME/.virtualenvs
# TODO: virtualenvwrapper makes zsh very slow
# source /usr/local/bin/virtualenvwrapper.sh

# Golang path
export GOROOT=/usr/local/go
export GOPATH=$HOME/golang
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
