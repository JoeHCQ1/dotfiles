#!/bin/bash

set -euo pipefail

###############################################################################
# Start Utility Functions                                                     #
###############################################################################

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
    
    release=$(curl -si "${url}" | grep "^location:" | grep -oE '[v]{0,1}[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}')
    if [ -z $release ]
    then
        error "determining latest version from ${url} built from argument ${base_url}"
    fi
    export release

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
        if [ "${3}" == "sudo" ]
        then
            info "adding ${1} to ${2} with sudo"
            echo "${1}" | sudo tee "${2}" >>/dev/null
        else
            info "adding ${1} to ${2}"
            echo "${1}" | tee "${2}" >>/dev/null
        fi
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

###############################################################################
# Start bash env customizations                                               #
###############################################################################

# Make local bin dir
LOCAL_BIN="${HOME}/.local/bin"
mkdir -p "${LOCAL_BIN}"

# Make goPath
mkdir -p "${HOME}/go"

info "Disabling ding bell alert" # https://unix.stackexchange.com/questions/73672/how-to-turn-off-the-beep-only-in-bash-tab-complete
[ -f "${HOME}/.inputrc" ] || touch "${HOME}/.inputrc"
add_line_to_file "set bell-style none" "${HOME}/.inputrc"

###############################################################################
# App install functions                                                       #
###############################################################################

install_ansible() {
    info "installing package ansible install"
    sudo apt install software-properties-common
    info "adding ansible ppa"
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    info "installing ansible"
    sudo apt install ansible
}

install_docker() {

    if [ ! -f "/usr/share/keyrings/docker-archive-keyring.gpg" ]
    then
        info "Adding docker gpg key to trusted keyring"
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    fi

    add_line_to_file "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" /etc/apt/sources.list.d/docker.list sudo

    info "Updating apt-get"
    sudo apt-get update
    info "Installing docker"
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    info "Adding user to docker group so docker can be run without sudo"
    sudo usermod -aG docker "${USER}"
}

install_fzf() {
    info "Installing FZF"
    mkdir -p ${HOME}/github.com/junegunn
    pushd ${HOME}/github.com/junegunn/ >>/dev/null

    if [ -d "fzf" ]
    then
        info "fzf was already cloned so will update"
        pushd fzf
        git pull || info "repo already up to date"
    else
        info "fzf has not yet been cloned so will clone"
        git clone --depth 1 https://github.com/junegunn/fzf.git fzf
        pushd fzf
    fi

    yes | bash install || [ $? -eq 141 ]

    popd
    popd
}

install_golang() {
    # Update the link here: https://go.dev/dl/
    pushd /tmp
    curl -LO https://go.dev/dl/go1.19.linux-amd64.tar.gz

    sudo tar -C /usr/local -xvf go1.19.linux-amd64.tar.gz

    popd
}

install_hadolint() {
    base_url="https://github.com/hadolint/hadolint"

    # set's `release` variable
    get_latest_github_release "${base_url}"

    executable_release_name="hadolint-Linux-x86_64"
    executable_desired_name="hadolint"

    dest="${LOCAL_BIN}"/"${executable_desired_name}"

    # set's download_url
    make_github_release_url "${executable_release_name}"

    info "Curling URL: ${download_url}"
    curl -LOs "${download_url/'//'/'/'}"

    info "Moving executable to destination."  
    mv "${executable_release_name}" "${dest}"

    make_executable "${dest}"
}

install_helm() {
    pushd /tmp
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    popd
}

install_k9s() {
    pushd /tmp/
    info "Curling down k9s"
    curl -LO  https://github.com/derailed/k9s/releases/download/v0.26.3/k9s_Linux_x86_64.tar.gz
    tar -xzf k9s_Linux_x86_64.tar.gz
    sudo mv k9s "${LOCAL_BIN}"/k9s
    info "k9s installed succesfully."
    popd
}

install_kind() {
    base_url="https://github.com/kubernetes-sigs/kind"

    # set's `release` variable
    get_latest_github_release "${base_url}"

    executable_release_name="kind-linux-amd64"
    executable_desired_name="kind"

    dest="${LOCAL_BIN}"/"${executable_desired_name}"

    # set's download_url
    make_github_release_url "${executable_release_name}"

    info "Curling URL: ${download_url}"
    curl -LOs "${download_url/'//'/'/'}"

    info "Moving executable to destination."  
    mv "${executable_release_name}" "${dest}"
}

install_kubectl() {
    # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    kubectl version --client
}

install_kubie() {
    base_url="https://github.com/sbstp/kubie"

    # set's `release` variable
    get_latest_github_release "${base_url}"

    executable_release_name="kubie-linux-amd64"
    executable_desired_name="kubie"

    dest="${LOCAL_BIN}"/"${executable_desired_name}"

    # set's download_url
    make_github_release_url "${executable_release_name}"

    info "Curling URL: ${download_url}"
    curl -LOs "${download_url/'//'/'/'}"

    info "Moving executable to destination."  
    mv "${executable_release_name}" "${dest}"

    make_executable "${dest}"
}

install_shellcheck() {
    base_url="https://github.com/koalaman/shellcheck/"

    get_latest_github_release $base_url

    pkg="shellcheck-${release}.linux.x86_64.tar.xz"
    executable
    _internal_path="shellcheck-${release}/shellcheck"
    executable_name="shellcheck"
    dest="${LOCAL_BIN}"/"${executable_name}"

    # Set's download_url var
    make_github_release_url ${pkg}

    info "Curling URL: ${download_url}."
    curl -LOs "${download_url/'//'/'/'}"

    info "Extracting ${executable_internal_path} from ${pkg}"
    tar --extract -f "${pkg}" "${executable_internal_path}"

    info "Moving extracted executable to destination."  
    mv "${executable_internal_path}" "${dest}"

    make_executable "${dest}"
}

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

## Comment/uncomment programs as desired and re-run idempotent script.

install_ansible
install_docker
install_fzf
install_golang
install_hadolint
install_helm
install_shellcheck
install_k9s
install_kind
install_kubectl
install_kubie
