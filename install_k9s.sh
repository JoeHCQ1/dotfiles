#!/bin/sh

set -e

pushd /tmp/

curl -LO https://github.com/derailed/k9s/releases/download/v0.25.21/k9s_Linux_x86_64.tar.gz
tar -xzf k9s_Linux_x86_64.tar.gz
sudo mv k9s /usr/local/bin/k9s

