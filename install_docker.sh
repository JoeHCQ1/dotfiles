#!/bin/bash

which docker && sudo apt-get remove docker
which docker-engine && sudo apt-get remove docker-engine
which docker.io && sudo apt-get remove docker.io
which containerd && sudo apt-get remove containerd
which runc && sudo apt-get remove runc

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker "${USER}"
