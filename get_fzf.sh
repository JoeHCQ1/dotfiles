#!/bin/bash

source utilities.sh

mkdir -p ${HOME}/github.com/junegunn

pushd ${HOME}/github.com/junegunn/ >>/dev/null

if [ -d "fzf" ]
then
    info "fzf was already cloned so will update"
    pushd fzf && git pull
else
    info "fzf has not yet been cloned so will clone"
    git clone --depth 1 https://github.com/junegunn/fzf.git fzf
    pushd fzf
fi

bash install

popd
popd
