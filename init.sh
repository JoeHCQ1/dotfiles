#!/bin/bash

set -e

bash install_standard_packages.sh
bash get_fzf.sh
bash get_hadolint.sh
bash get_shellcheck.sh
bash modify_bashrc.sh
bash install_duo.sh
bash install_docker.sh
bash disable_bell.sh
