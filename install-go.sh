#!/bin/bash

# Update the link here: https://go.dev/dl/
pushd /tmp
curl -LO https://go.dev/dl/go1.18.2.linux-amd64.tar.gz

sudo tar -C /usr/local -xvf go1.18.2.linux-amd65.tar.gz

popd

