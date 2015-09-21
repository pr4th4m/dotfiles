# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


##### My Configuration ####

# git status on right prompt
setopt prompt_subst
. ~/git-prompt.sh
export RPROMPT=$'%F{blue}$(__git_ps1 "%s")'
# export PROMPT='%F{green}%n%f@%F{green}%m%f%b:%F{yellow}%~ %b$%B%F{grey}%f%b '
export PROMPT='%F{yellow}%~ %b$%B%F{grey}%f%b '
export GIT_PS1_SHOWDIRTYSTATE=1

# for 256 color support
if [ -n "$TMUX" ]; then
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi

# vi key bindings
bindkey -v
export KEYTIMEOUT=1

# make vim as default editor
export EDITOR=vim

# NOTE: Add new python path
# as per you requirments.
# Just a sample of how to do it
# PYTHONPATH="/home/pratz/Repos:$PYTHONPATH"
# export PYTHONPATH

# set virtualenvwrapper path
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# Home brew installation path
export PATH="/usr/local/bin:$PATH"

# point docker client to docker-machine.
# eval "$(docker-machine env default)"

export GOPATH=$HOME/golang
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin
