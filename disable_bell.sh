#!/bin/bash

set -e

# https://unix.stackexchange.com/questions/73672/how-to-turn-off-the-beep-only-in-bash-tab-complete

[ -f "${HOME}/.inputrc" ] || touch "${HOME}/.inputrc"

source utilities.sh

info "Disabling bell"
add_line_to_file "set bell-style none" "${HOME}/.inputrc"
