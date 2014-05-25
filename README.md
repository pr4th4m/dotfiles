## Auto deploy configuration files on new machine

### What are we configuring:
* vim
* guake
* zsh and (oh-my-zsh)
* tmux 
* conky

### Tweak:
* For directory color fix.

    ``` 
    cd
    wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
    mv dircolors.ansi-dark .dircolors
    eval `dircolors ~/.dircolors`
    ```

* Guake solarized color scheme

    ```
    cd
    git clone https://github.com/coolwanglu/guake-colors-solarized.git
    cd guake-colors-solarized
    ./set_dark.sh
    ```

### Prerequisite:
* GNU Stow
* Installation on ubuntu -
`sudo apt-get install stow`

### How to deploy:
* Move to the directory where you cloned this repo - 
`cd ~/dotfiles`
* Delpoy - `stow -v <package_name>`
* To remove - `stow -vD <package_name>`
* To re-stow - `stow -vR <package_name>`

### Available packages:
* vim.complete (with all plugins)
* vim.mini (with minimum plugins)
* git
* tmux
* zsh
* xterm
* conky

### Tips:
* To install every thing at once use following command
    ```
    stow -v vim.mini git tmux zsh xterm conky
    ```
