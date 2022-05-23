#!/bin/bash

source utilities.sh

info "adding the bash aliases to be sourced."
source_this "${PWD}/bash_aliases.sh"

info "adding the bash customizations to be sourced."
source_this "${PWD}/bash_customizations.sh"
