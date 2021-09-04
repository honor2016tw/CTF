#!/bin/sh

apt-get update
apt-get install -y git sudo bash make vim nano curl 
dpkg --add-architecture i386 
apt-get update 
apt-get install -y $(grep -vE "^\s*#" /tmp/packagelist  | tr "\n" " ")

pip install -U ipython pycrypto capstone pwntools ropgadget

git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc 
