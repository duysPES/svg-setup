#! /bin/bash
# cd to home directory
cd ~

# update apt
sudo apt update && sudo apt upgrade -y

# redundancy
sudo apt update --fix-missing && sudo apt upgrade -y

# download appropriate apt packages
sudo apt install virtualenv python3.7 python3-tk nodm xserver-xorg xinit openbox emacs -y

# create virtualenv and set python variables
virtualenv --python=python3.7 ~/py

py="/home/pi/py/bin/python"
pip="/home/pi/py/bin/pip"

# install appropriate pip package
$pip install pyserial pysimplegui ipython 

# clone latest svg
git clone https://github.com/duysPES/shooting-verification-gui svg

# need to add a test here to make sure all py libraries are good to go.


