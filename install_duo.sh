#!/bin/bash

set -e

pushd /tmp

curl -LO https://dl.duosecurity.com/DuoConnect-latest.tar.gz
tar -xzvf DuoConnect-latest.tar.gz
sudo ./install.sh
rm install.sh

popd

bash /mnt/c/Users/jrichardson/setup_kr_ssh.sh
