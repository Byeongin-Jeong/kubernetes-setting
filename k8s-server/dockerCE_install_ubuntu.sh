#!/bin/bash

# ubuntu 22.04 LTS version

# Install Start
echo "################# Install Docker start #################"
echo " "

#1. Repository Update and Install
echo "################# Repository install #################"
echo " "
apt-get update
apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
echo " "

#2. Register GPG Key and stable repository
echo "################# Register GPG Key/stable repository #################"
echo " "
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo " "

# Docker Version 23.0.2
#3. dockerCE install(lastes stable ver.)
echo "################# dockerCE install #################"
echo " "
apt-get update
apt-get install -y docker-ce=5:23.0.2-1~ubuntu.22.04~jammy docker-ce-cli=5:23.0.2-1~ubuntu.22.04~jammy containerd.io
echo " "

#4. Add User In Docker Group
echo "################# Add User In Docker Group #################"
echo " "
sudo usermod -aG docker $USER
echo " "

docker version
# Install Finish
echo "################# Install Docker finish #################"
echo " "