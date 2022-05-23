#!/bin/bash

HISTSIZE=10000
HISTFILESIZE=20000

export DOCKER_BUILDKIT=1
export EDITOR=vim

PATH="${HOME}/bin":"${HOME}/.local/bin":${PATH}

[ -f "${HOME}/.fzf.bash" ] && source "${HOME}/.fzf.bash"

if [ ! -f "${HOME}/.git-sh-prompt.sh" ];
then
    cp /usr/lib/git-core/git-sh-prompt ~/.git-sh-prompt.sh
fi

. "${HOME}/.git-sh-prompt.sh"

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\w$(__git_ps1 " (%s)")\$ '

emoji () {
    if [ $? -eq 0 ]
    then
        echo 😎
    else
        echo 💥
    fi
}

PS1='\[\e[0;37m\]\u \[\e[0;32m\]\w\[\e[0m\]$(__git_ps1 " (%s)") \[\e[1;31m\]\t\[\e[0m\] $(emoji)\n\[\e[0;37m\]λ\[\e[0m\] '
