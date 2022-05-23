#!/bin/bash

set -e

mkdir -p "${HOME}/bin/"

RED='\e[1;31m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'

error () {
    echo -e "${RED}ERROR:${NC} ${1}" >>/dev/stderr
    popd
    exit 1
}

warnings=()

print_warning () {
    echo -e "${YELLOW}WARNING:${NC} ${1}" >>/dev/stderr
}

warning () {
    print_warning "${1}"
    warnings+=("${1}")
}

info () {
    echo -e "${WHITE}INFO:${NC} ${1}"
}

# Expects base url as 1st arg
# Set's release variable in global namespace.
function get_latest_github_release() {

    if [ -z $base_url ]
    then
        [ -z $1 ] && error "Calling script did provide set base_url or provide as argument."
        info "Using argument to set base_url: ${1}"
        base_url="${1}"
    else
        info "Using base_url as set in larger namespace: ${base_url}"
    fi

    url="${base_url}"/releases/latest
    
    export release
    release=$(curl -s "${url}" | grep -oE '[v]{0,1}[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}') || error "in URL ${url} built from argument ${base_url}"

    info "found version: ${release}"
}

function make_github_release_url() {
    export download_url
    download_url="${base_url}"/releases/download/"${release}"/"${1}"
}

function make_executable() {
    info "Making ${1} executable by all $USER"
    sudo chown "${USER}":"${USER}" "${1}" && sudo chmod 0755 "${1}"
}

function add_line_to_file() {
    [ -f "${2}" ] || touch "${2}"
    if [ ! -z "$(grep "${1}" "${2}")" ]
    then
        info "${2} already contains '${1}'"
    else
        info "adding ${1} to ${2}"
        cat >> "${2}" << EOF
${1}
EOF
    fi
}

function source_this() {
    [ -z $1 ] && error "source_this requires an argument!"
    [ -f "${1}" ] || warning "The file to be sourced does not yet exist: ${1}"
    
    FILE="${HOME}/.bashrc"
    STRING="[ -f ~${1//${HOME}/} ] && source ~${1//${HOME}/}"
    info "sourcing ${1} in .bashrc file"
    add_line_to_file "${STRING}" "${FILE}"
}

function curl_and_chown_github_executable() {
    if [ -z $executable_release_name ]
    then
        [ -z $1 ] && error "Calling script did provide set executable_release_name or provide as argument."
        info "Using argument to set executable_release_name: ${1}"
        executable_release_name="${1}"
    else
        info "Using executable_release_name as set in larger namespace: ${executable_release_name}"
    fi


}