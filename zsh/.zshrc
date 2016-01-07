# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

##### My Configuration ####

# git status on right prompt
setopt prompt_subst
source ~/git-prompt.sh
export RPROMPT=$'%F{blue}$(__git_ps1 "%s")'
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

### Path for virtual env wrapper
# NOTE: Config for virtual python env wrapper
# install virtual env wrapper and uncomment the following
export WORKON_HOME="$HOME/.virtualenvs"
export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python2.7"
source /usr/local/bin/virtualenvwrapper.sh

# fix for 'ls' in solarized
# eval `dircolors ~/.dircolors`

# # NOTE: Config for fuzzy finder
# # install fuzzy finder and uncommnet it
# set -o vi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# # fzf_history() { zle -I; eval $(history | fzf +s | sed 's/ *[0-9]* *//') ; }; zle -N fzf_history; bindkey '^H' fzf_history
# # fzf_killps() { zle -I; ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9} ; }; zle -N fzf_killps; bindkey '^Q' fzf_killps
# # fzf_cd() { zle -I; DIR=$(find ${1:-*} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf) && cd "$DIR" ; }; zle -N fzf_cd; bindkey ' f' fzf_cd
# fe() { local file; file=$(fzf --query="$1" --select-1 --exit-0); [ -n "$file" ] && ${EDITOR:-vim} "$file"; };

# point docker client to docker-machine.
# eval "$(docker-machine env default)"

export GOROOT=/usr/local/go
export GOPATH=$HOME/golang
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
