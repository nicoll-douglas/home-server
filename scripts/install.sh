#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd $CURRENT_DIR

echo "Installing utilities"
sudo apt-get update
sudo apt install -y build-essential git

echo "Adding network configuration to /etc/network/interfaces"
sudo cp ../config/interfaces.server /etc/network/interfaces

echo "Installing ufw"
sudo apt install -y ufw

echo "Adding ufw-docker config to /etc/ufw/after.rules"
sudo cat ../config/ufw/ufw-docker >> /etc/ufw/after.rules

echo "Adding current rules to ufw"
while IFS= read -r rule; do
  sudo ufw $rule
done < ../config/ufw/rules

echo "Enabling ufw"
sudo ufw enable

echo "Installing and setting up Docker"

echo "Adding Docker's official GPG key"
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Adding Docker repository to list of Apt sources"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update