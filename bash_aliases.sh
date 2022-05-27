#!/bin/bash

alias sl=ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"

if which vim >>/dev/null
then
    alias vi=vim
    alias v=vim
fi

if which kubectl >>/dev/null
then
    source <(kubectl completion bash)
    alias k=kubectl
    complete -F __start_kubectl k
fi

if which minikube >>/dev/null
then
    alias mk=minikube
fi

if which k9s >>/dev/null
then
    alias k9=k9s
fi

if which kubie >>/dev/null
then
    alias kx="kubie ctx"
    alias ks="kubie ns"
fi

if which helm >>/dev/null
then
    alias chart=helm
fi

export KUBECONFIG="${HOME}/.kube/kubeconfig"

alias here='echo $PWD'

if which shellcheck >>/dev/null
then
    alias shellcheckr="shellcheck \$(find . -type f -name \"*.sh\")"
fi

alias surrender='sudo chown -R $USER:$USER .'

if which helm >>/dev/null
then
    alias chart="helm"
fi

alias refresh="source ~/.bashrc"

if which docker >>/dev/null
then
    alias dk="docker"
fi

if which docker-compose >>/dev/null
then
    alias dc="docker-compose"
fi

remove_git_submodule ()
{
    git submodule deinit -f -- "${1}";
    rm -rf .git/modules/"${1}";
    git rm -f "${1}"
}

# For use in `git`
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

alias gs="git status"
alias gm="git commit"
alias gp="git push"
alias gpf="git push --force"
