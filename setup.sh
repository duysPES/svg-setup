#! /bin/bash
# cd to home directory
cd ~

# update apt
sudo apt update && sudo apt upgrade -y

# redundancy
sudo apt update --fix-missing && sudo apt upgrade -y

# download appropriate apt packages
sudo apt install build-essential virtualenv python3.7 python3.7-dev python3-tk nodm xserver-xorg xinit openbox emacs -y

# create virtualenv and set python variables
virtualenv --python=python3.7 /home/pi/py

py="/home/pi/py/bin/python"
pip="/home/pi/py/bin/pip"

# install appropriate pip package
$pip install pyserial pysimplegui ipython cython

# clone latest svg
git clone https://github.com/duysPES/shooting-verification-gui svg

CRED_PATH="/home/pi/svg/pysrc"
CRED_FNAME="credentials"
CRED_USERNAME="duanuys"
CRED_PASSWORD="Dawie2018"
PY_VERSION="3"
PYTHONLIB="python3.7m"
echo $CRED_PATH, $CRED_FNAME
# write native python func that checks credentials
printf "%s\n" \
  "def check_credentials(name, password):" \
  "    if name != '${CRED_USERNAME}':" \
  "        return False" \
  "    if password != '${CRED_PASSWORD}':" \
  "        return False" \
  "    return True" \
  > $CRED_PATH/$CRED_FNAME.py
  
  # use cython to convert to *.c
  $py -m cython $CRED_PATH/$CRED_FNAME -$PY_VERSION -i
 
  # now clean up files that we don't need.
  rm $CRED_PATH/$CRED_FNAME.*

  

