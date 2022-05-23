#!/bin/bash

set -e

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y curl vim tree git gcc build-essential make clang clang-format

sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y default-jdk

sudo apt-get install -y python-is-python3 python3-pip

sudo apt-get install -y default-jre


