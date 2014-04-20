## Auto deploy configuration files on new machine

### Prerequisite:
* GNU Stow
* Installation on ubuntu -
`sudo apt-get install stow`

### How to delopy:
* Move to the directory where you cloned this repo - 
`cd ~/dotfiles`
* Delpoy - `stow wenv`
* To remove - `stow -D wenv`
* To re-stow - `stow -R wenv`
