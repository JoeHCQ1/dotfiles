#!/bin/bash

source utilities.sh

base_url="https://github.com/koalaman/shellcheck/"

get_latest_github_release

pkg="shellcheck-${release}.linux.x86_64.tar.xz"
executable_internal_path="shellcheck-${release}/shellcheck"
executable_name="shellcheck"
dest=${HOME}/bin/"${executable_name}"

# Set's download_url var
make_github_release_url ${pkg}

info "Curling URL: ${download_url}."
curl -LOs "${download_url/'//'/'/'}"

info "Extracting ${executable_internal_path} from ${pkg}"
tar --extract -f "${pkg}" "${executable_internal_path}"

info "Moving extracted executable to destination."  
sudo mv "${executable_internal_path}" "${dest}"

make_executable "${dest}"
