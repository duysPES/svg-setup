#! /bin/bash

HOME="/home/pi"

# cd to home directory
cd ~

# update apt
sudo apt update --fix-missing && sudo apt upgrade -y

# download appropriate apt packages
sudo apt install build-essential virtualenv python3.7 python3.7-dev python3-tk nodm xserver-xorg xinit openbox xterm emacs -y

# create virtualenv and set python variables
virtualenv --python=python3.7 $HOME/py

py="${HOME}/py/bin/python"
pip="${HOME}/py/bin/pip"
cythonize="${HOME}/py/bin/cythonize"

# install appropriate pip package
$pip install pyserial pysimplegui ipython cython

# clone latest svg
git clone https://github.com/duysPES/shooting-verification-gui $HOME/svg

CRED_PATH="${HOME}/svg/pysrc"
CRED_FNAME="credentials"
CRED_USERNAME="duanuys"
CRED_PASSWORD="Dawie2018"
PY_VERSION="3"
echo $CRED_PATH, $CRED_FNAME
# write native python func that checks credentials
printf "%s\n" \
  "def check_credentials(name, password):" \
  "    if name != '${CRED_USERNAME}':" \
  "        return False" \
  "    if password != '${CRED_PASSWORD}':" \
  "        return False" \
  "    return True" \
  > $CRED_PATH/$CRED_FNAME.pyx
  
  # use cython to convert to *.c
 $cythonize $CRED_PATH/$CRED_FNAME.pyx -$PY_VERSION -i
 
  # now clean up files that we don't need.
  rm $CRED_PATH/$CRED_FNAME.pyx
  rm $CRED_PATH/$CRED_FNAME.c

  # now add udev rules to gaurantee that ttyUSB0 is always readable/writable
 # UDEV="/etc/udev/rules.d"
 # sudo printf "%s\n" \
 #   "KERNEL==\"ttyUSB0\", MODE=\"0666\" \
 #   > $UDEV/usb0-always-editable.rules
 
 #configure nodm
 sudo sed -i -e "s/NODM_ENABLED=false/NODM_ENABLED=true/" -e "s/NODM_USER=root/NODM_USER=pi/" \
  /etc/default/nodm
  
  
 mkdir -p $HOME/.config/openbox
 
 MAIN_PY="${HOME}/svg/main.py"
 # write autostart
 printf "%s\n" \
  "#!/usr/bin/env bash" \
  "exec openbox-session &" \
  "while true; do"\
  "    ${py} ${MAIN_PY}" \
  "done" \
  > ~/.config/openbox/autostart
 
 echo "Done with setup, recommended to reboot"

