# From Ubuntu repository
# Install work environment
sudo apt-get install -y vim-gnome
sudo apt-get install -y zsh
sudo apt-get install -y guake
sudo apt-get install -y tmux
sudo apt-get install -y stow
sudo apt-get install -y git
sudo apt-get install -y xclip
sudo apt-get install -y ack-grep
sudo apt-get install -y ctags

# Servers
sudo apt-get install -y openssh-server
sudo apt-get install -y openssh-client

# Languages
sudo apt-get install -y python-setuptools

# Python package installer
sudo easy_install pip
sudo pip install -U pip
sudo pip install ipython
sudo pip install ipdb
sudo pip install virtualenv
sudo pip install virtualenvwrapper

# Appearance 
sudo apt-get install -y conky
sudo apt-get install -y fonts-inconsolata

# Add ons
sudo apt-get install -y radiotray
sudo apt-get install -y xubuntu-restricted-addons 
sudo apt-get install -y xubuntu-restricted-extras 

# Utilities
sudo apt-get install -y gdebi


# Third Party repository
sudo add-apt-repository -y ppa:appgrid/stable
sudo apt-get update
sudo apt-get install -y appgrid

sudo apt-add-repository -y ppa:synapse-core/testing
sudo apt-get update
sudo apt-get install -y synapse

sudo add-apt-repository -y ppa:yorba/ppa
sudo apt-get update
sudo apt-get install -y geary


# Other configuration
# For terminal color fix
cd
wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
mv dircolors.ansi-dark .dircolors
eval `dircolors ~/.dircolors`

# For terminal color
cd
git clone https://github.com/coolwanglu/guake-colors-solarized.git
cd guake-colors-solarized
./set_dark.sh
