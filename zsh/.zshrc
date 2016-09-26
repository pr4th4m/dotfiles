# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

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
# directory color fix
eval `dircolors ~/.dircolors`

# vi key bindings
bindkey -v
export KEYTIMEOUT=1

# for 256 color support
if [ -n "$TMUX" ]; then
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi

# make vim as default editor
export EDITOR=nvim

# set virtualenvwrapper path
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# Install:
#   wget https://storage.googleapis.com/golang/go1.5.linux-amd64.tar.gz
#   sudo tar -C /usr/local -xzf go1.5.linux-amd64.tar.gz
# Remove
#   sudo rm -rf /usr/local/go
export GOROOT=/usr/local/go
export GOPATH=$HOME/goworkspace
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
