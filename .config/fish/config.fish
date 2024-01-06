if status is-interactive
    # Commands to run in interactive sessions can go here
end

# disable welcome message
set -g fish_greeting

# vi settings
fish_vi_key_bindings
bind --mode insert --sets-mode default jj repaint
bind -M vi k history-search-backward
bind -M vi j history-search-forward

# search history with ctrl-p/ctrl-n in insert mode
bind -M insert \cp history-search-backward
bind -M insert \cn history-search-forward
# bind [ history-token-search-backward
# bind ] history-token-search-forward
bind -M insert \cj accept-autosuggestion

# remove vi mode indicator
function fish_mode_prompt; end

# override kitty clear scrollback functionality
function clear_only_screen_and_save_content_in_scrollback
    printf "\e[H\e[22J"
    printf "\e[H\e[2J"
    fish_prompt
end
bind -M insert \cl clear_only_screen_and_save_content_in_scrollback

# alias
# https://hasseg.org/trash/
alias rm='trash -F'
alias rg='rg --hyperlink-format=kitty'
alias cs='cht.sh'
# alias ls='gls --color --group-directories-first --hyperlink=auto'
# alias ll='gls -lh --color --group-directories-first --hyperlink=auto'
# alias cat='bat -pp --theme base16'

# Golang path
set GOROOT /usr/local/go
set GOPATH $HOME/go
set GOBIN $GOPATH/bin

# set virtualenvwrapper path
set VIRTUALENVWRAPPER_PYTHON /usr/local/bin/python3
set WORKON_HOME $HOME/.virtualenvs

# fzf settings
set FZF_DEFAULT_COMMAND "fd --type f --color=never --exclude .git --exclude node_modules $FZF_HIDDEN" 
set FZF_DEFAULT_OPTS '--layout=reverse --border'

set FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set FZF_CTRL_T_OPTS "--height 90% --preview 'bat --theme Nord --plain --pager never --color always {} | head -500'"

bind -M insert \ce  fzf-cd-widget
set FZF_ALT_C_COMMAND "fd --type d --color=never --exclude .git --exclude node_modules $FZF_HIDDEN"
set FZF_ALT_C_OPTS "--height 90% --preview 'tree -C {} | head -500'"

# zk cli
set ZK_NOTEBOOK_DIR "/Users/ghar/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/notes/"

# Add paths
fish_add_path /usr/local/bin /usr/local/opt/curl/bin $HOME/.cargo/bin $HOME/Library/Python/2.7/bin $HOME/Library/Python/3.9/bin /usr/local/opt/mysql-client/bin /usr/local/opt/libpq/bin /usr/local/sbin $HOME/.garden/bin $GOPATH/bin $GOROOT/bin
