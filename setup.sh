#! /bin/bash

HOME="/home/pi"

while true; do
  read -p "Download binary?" yn
  case $yn in 
    [Yy]* ) BINARY=true; echo "version?"; read VERSION; break;;
    [Nn]* ) BINARY=false; break;;
    * ) echo "Please answer yes or no.";;
  esac
done

# update apt
sudo apt update --fix-missing && sudo apt upgrade -y

# get packages related to GUI.
sudo apt install build-essential nodm xserver-xorg xinit xterm openbox -y

#configure nodm
sudo sed -i -e "s/NODM_ENABLED=false/NODM_ENABLED=true/" -e "s/NODM_USER=root/NODM_USER=pi/" \
/etc/default/nodm
  
  
# diverge path here, either install source and compile or.. download latest version based on version number
if [ $BINARY ]
then 
  # download latest binary
else
  echo "Doing this from source then.."

  # download appropriate apt packages
  sudo apt install build-essential virtualenv python3.7 python3.7-dev python3-tk -y

  # set git credentials
  git config --global user.email "duys@pioneeres.com"
  git config --global user.name "duysPES"

  # create virtualenv and set python variables
  virtualenv --python=python3.7 $HOME/py

  py="${HOME}/py/bin/python"
  pip="${HOME}/py/bin/pip"
  cythonize="${HOME}/py/bin/cythonize"

  # install appropriate pip package
  $pip install pyserial pysimplegui ipython cython pyinstaller

  # clone latest svg
  git clone https://github.com/duysPES/shooting-verification-gui $HOME/svg

  echo "***Serializing credentials***"
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
  
  # use cython to convert to shared *.so
  $cythonize $CRED_PATH/$CRED_FNAME.pyx -$PY_VERSION -i
 
  # now clean up files that we don't need.
  rm $CRED_PATH/$CRED_FNAME.pyx
  rm $CRED_PATH/$CRED_FNAME.c
 fi
 
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

