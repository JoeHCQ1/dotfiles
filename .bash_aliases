#!/bin/bash

alias sl=ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"

alias gs="git status"
alias gm="git commit"
alias gp="git push"
alias gpf="git push --force"

## Alias VIM to avoid frustrating state of running vi
if command -v vim &> /dev/null
then
    alias vi=vim
    alias v=vim
fi

## Enable kubectl bash completion
## and setup kubectl bash completion to work with the alias `k`
if command -v kubectl &> /dev/null
then
    source <(kubectl completion bash)
    alias k=kubectl
    complete -F __start_kubectl k
fi

## Enable helm bash completion
## and setup kubectl bash completion to work with the alias `chart`
if command -v helm &> /dev/null
then
    source <(helm completion bash)
    alias chart=helm
    complete -F __start_helm chart
fi

## allow k9s mistype k9 to work
if command -v k9s &> /dev/null
then
    alias k9=k9s
fi

## Setup retro kubectx and kubens aliases for kubie
if command -v kubie &> /dev/null
then
    alias kx="kubie ctx"
    alias ks="kubie ns"
fi

## Alias a recursive shellcheck
if command -v shellcheck &> /dev/null
then
    alias shellcheckr="shellcheck \$(find . -type f -name \"*.sh\")"
fi

## Docker is such a long word, though ergonmic to type, so not too bad
if command -v docker &> /dev/null
then
    alias dk="docker"
fi

## Docker-compose is really long, dc is much faster
if command -v docker-compose &> /dev/null
then
    alias dc="docker-compose"
fi

## Intuitive alias to get current location
alias here='echo $PWD'

## Convienence to return files to my possession after say mounting
## into a docker image where they're modified by root.
alias surrender='sudo chown -R $USER:$USER .'

## Nice way to quickly reload changes to the bash env
alias refresh="source ~/.bashrc"

## Git submodules are a massive pain to get rid of. This func is helpful.
remove_git_submodule ()
{
    git submodule deinit -f -- "${1}";
    rm -rf .git/modules/"${1}";
    git rm -f "${1}"
}

## Useful when using WSL2 where the WSL2 git is super slow when in a
## Windows directory and vice versa for the Windows Git in a WSL2 directory.
## This is used in the git function below.
isWinDir () {
        case $PWD/ in
                (/mnt/*) return 0 ;;
                (*) return 1 ;;
        esac
}

git () {
    if isWinDir
    then
        git.exe "$@"
    else
        /usr/bin/git "$@"
    fi
}

###############################################################################
# Start bash env customizations                                               #
###############################################################################

HISTSIZE=10000
HISTFILESIZE=20000

# Set docker to use new build engine
export DOCKER_BUILDKIT=1
# Set default editor to Vim (death to nano!)
export EDITOR=vim

PATH="${HOME}/.local/bin:${PATH}"

# Add GOPATH
GOPATH="${HOME}/go"
export GOPATH
# Add Go executables to path
PATH="/usr/local/go/bin/":"${GOPATH}/bin":"${PATH}"
export PATH

## Setup Git prompt - get the file into HOME
if [ ! -f "${HOME}/.git-sh-prompt.sh" ];
then
    # This is /usr/lib/git-core in debian, /usr/libexec/git-core in fedora
    cp /usr/lib/git-core/git-sh-prompt ~/.git-sh-prompt.sh || cp /usr/libexec/git-core/git-sh-prompt ~/.git-sh-prompt.sh
fi
. "${HOME}/.git-sh-prompt.sh"

## Enable git prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\w$(__git_ps1 " (%s)")\$ '

## Create emoji func for prompt
emoji () {
    if [ $? -eq 0 ]
    then
        echo ":D"
    else
        echo "¯\_(ツ)_/¯"
    fi
}

## Use custom prompt!
PS1='\[\e[0;37m\]\u \[\e[0;32m\]\w\[\e[0m\]$(__git_ps1 " (%s)") \[\e[1;31m\]\t\[\e[0m\] $(emoji)\n\[\e[0;37m\]λ\[\e[0m\] '

