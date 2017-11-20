#### zPlug - zsh plugin manager ####
source ~/.zplug/init.zsh

# Self update zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Command completions
zplug "zsh-users/zsh-completions"

# Syntax highlighting for commands
zplug "zsh-users/zsh-syntax-highlighting"

# Quickly search history
zplug "zsh-users/zsh-history-substring-search", defer:2

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
# directory color fix
eval `dircolors ~/.dircolors`

# vi key bindings
bindkey -v
export KEYTIMEOUT=1

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
alias ls='ls -G --color'
alias ll='ls -lh'

# for 256 color support
if [ -n "$TMUX" ]; then
    export TERM=tmux-256color
else
    export TERM=xterm-256color
fi

# make vim as default editor
export EDITOR=nvim

# Let fzf use rg
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

#### Required paths #####

# Set python path for user installation
# When installed with `pip install <package> --user`
export PATH="$HOME/.local/bin:$PATH"

# set virtualenvwrapper path
export WORKON_HOME=$HOME/.virtualenvs
# TODO: Figure out why virtualenvwrapper makes zsh very slow
# source /usr/local/bin/virtualenvwrapper.sh

# Install:
#   wget https://storage.googleapis.com/golang/go1.5.linux-amd64.tar.gz
#   sudo tar -C /usr/local -xzf go1.5.linux-amd64.tar.gz
# Remove
#   sudo rm -rf /usr/local/go
export GOROOT=/usr/local/go
export GOPATH=$HOME/goworkspace
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
