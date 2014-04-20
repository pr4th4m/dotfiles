## Auto deploy configuration files on new machine

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
