#!/bin/bash

set -e

curl -LO https://github.com/sbstp/kubie/releases/download/v0.16.0/kubie-linux-amd64
mv kubie-linux-amd64 ${HOME}/bin/kubie
chmod +x ${HOME}/bin/kubie

