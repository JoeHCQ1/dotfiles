#!/bin/bash

source utilities.sh

base_url="https://github.com/hadolint/hadolint"

# set's `release` variable
get_latest_github_release "${base_url}"

executable_release_name="hadolint-Linux-x86_64"
executable_desired_name="hadolint"

dest=${HOME}/bin/"${executable_desired_name}"

# set's download_url
make_github_release_url "${executable_release_name}"

info "Curling URL: ${download_url}."
curl -LOs "${download_url/'//'/'/'}"

info "Moving executable to destination."  
sudo mv "${executable_release_name}" "${dest}"

make_executable "${dest}"
