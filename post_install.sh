#!/bin/bash
###########################################################################
#
#     COPYRIGHT (C) 2025
#
###########################################################################
#
#     Author:  Casey Cannady - me@caseycannady.com
#
###########################################################################
#
#     Script:  post_install.sh
#     Version: 1.0
#     Created: 01/20/2025
#     Updated: 01/23/2025
#
###########################################################################

#
# Let's get started!
#
echo " "
echo "[*** STARTING | post_install.sh | `date` ***]"

#
# Store the current path
#
sPWD=$(pwd)

#
# Run APT update commands
#
echo " "
echo "Performing APT update commands"
systemctl daemon-reload
apt-get update -y --fix-missing
apt-get full-upgrade -y --fix-missing
apt-get dist-upgrade -y --fix-missing
apt-get clean -y
apt-get autoremove -y

#
# Remove packages that won't be used
#
echo " "
echo "Removing preinstalled packages that will not be used."
apt purge aisleriot* gnome-games gnome-mahjongg gnome-mines gnome-sudoku rhythmbox* shotwell* thunderbird* -y && apt autoremove -y

#
# Download and install Google Chrome
#
echo " "
echo "Downloading and installing Google Chrome browser for all users."
cd "/tmp"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb
cd $sPWD

#
# Install all additional repo packages
#
echo " "
echo "Installing additional APT packages from default repos."
sudo apt install nmon gimp postgresql postgresql-contrib snapd geany docker.io nodejs npm python3-pip gnome-tweaks apache2 mysql-server php libapache2-mod-php php-mysql git vscode nodejs npm python3 python3-pip openjdk-17-jdk maven gradle docker.io docker-compose build-essential cmake gnome-shell-extension-manager -y

#
# Install all additional snaps
#
echo " "
echo "Installing additinal SNAPs."
snap install appflowy postman dbeaver-ce

#
# Install all pips
#
echo " "
echo "Installing additional PIP3s."
pip3 install tensorflow

#
# Install npms
#
echo " "
echo "Installing additional NPMs."
npm install -g joplin

#
# Install Ollama locally
#
echo " "
echo "Installing Ollama locally."
curl -fsSL https://ollama.com/install.sh | sh;

#
# Good housekeeping
#
rm -f /tmp/google-chrome-stable_current_amd64.deb

#
# Check if reboot is required and notify user.
#
echo " ";
if [ -f /var/run/reboot-required ] 
then
    echo "[*** Attention $USER: you must reboot your machine ***]"
else
    echo "[*** Attention $USER: your device has been updated ***]"
fi

#
# We're done!
#
echo " "
echo "[*** FINISHED | post_install.sh | `date` ***]"
echo " "
exit