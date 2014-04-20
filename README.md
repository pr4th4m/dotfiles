## Auto deploy configuration files on new machine

### To are we configuring:
* vim
* guake
* zsh and (oh-my-zsh)
* tmux 

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

### How to delopy:
* Move to the directory where you cloned this repo - 
`cd ~/dotfiles`
* Delpoy - `stow -v wenv`
* To remove - `stow -vD wenv`
* To re-stow - `stow -vR wenv`
