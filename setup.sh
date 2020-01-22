#! /bin/bash

# update apt
sudo apt upgrade && sudo apt update -y

# download appropriate apt packages
sudo apt install virtualenv python3.7 python3-tk -y

# create virtualenv and set python variables
virtualenv --python=python3.7 ~/py

py="/home/pi/py/bin/python"
pip="/home/pi/py/bin/pip"

# install appropriate pip package
$pip install pyserial pysimplegui ipython 

# clone latest svg
git clone https://github.com/duysPES/shooting-verification-gui svg


