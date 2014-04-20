# To install - git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh 
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="af-magic"
ZSH_THEME="clean"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(vi-mode pip)

source $ZSH/oh-my-zsh.sh

# OMZ search plugin
source $ZSH/plugins/history-substring-search/history-substring-search.zsh

# Customize to your needs...
export PATH=$PATH:/usr/local/heroku/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games


##### My Configuration ####

# for 256 color support
if [ -n "$TMUX" ]; then
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi

# hand full aliases
alias l='ls -l'
alias c='clear'

# NOTE: Add new python path
# as per you requirments.
# Just a sample of how to do it
# PYTHONPATH="/home/pratz/PyLab:$PYTHONPATH"
# export PYTHONPATH

### Path for virtual env wrapper
# NOTE: Config for virtual python env wrapper
# install virtual env wrapper and uncomment the following
# export WORKON_HOME="$HOME/.virtualenvs"
# export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python2.7"
# source /usr/local/bin/virtualenvwrapper.sh

# fix for 'ls' in solarized 
eval `dircolors ~/.dircolors`

# NOTE: Config for fuzzy finder
# install fuzzy finder and uncommnet it
# source ~/.fzf.zsh
# fzf_history() { zle -I; eval $(history | fzf +s | sed 's/ *[0-9]* *//') ; }; zle -N fzf_history; bindkey '^H' fzf_history
# fzf_killps() { zle -I; ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9} ; }; zle -N fzf_killps; bindkey '^Q' fzf_killps
# fzf_cd() { zle -I; DIR=$(find ${1:-*} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf) && cd "$DIR" ; }; zle -N fzf_cd; bindkey '^F' fzf_cd
