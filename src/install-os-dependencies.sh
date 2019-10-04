#!/bin/bash

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/vars.sh

# Dependencies
COMMANDS_REQUIRED="curl wget zip unzip jq python3 virtualenv crudini awk make bash"
PACKAGES_UBUNTU="curl wget zip unzip jq python3 virtualenv crudini gawk make bash"

# Check if all commands do exist
INSTALLATION_REQUIRED="false"
for __command in ${COMMANDS_REQUIRED}
do
    if ! command_loc="$(type -p "$__command")" || [[ -z $command_loc ]]; then
        log_warning "Missing ${__command}. It will be installed."
        INSTALLATION_REQUIRED="true"
        echo $__command
    fi
done

# Install dependencies
# UBUNTU
if command_loc="$(type -p "apt-get")" || [[ -z $command_loc ]] && [ "$INSTALLATION_REQUIRED" == "true" ]
then
    SUDO='sudo'
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=''
    fi
    log_info "[os_dependencies] Installing '${PACKAGES_UBUNTU}'. May be asked for password."
	${SUDO} apt-get update -qq
	${SUDO} apt-get install -q -y ${PACKAGES_UBUNTU}
fi

log_info "[os_dependencies] All dependencies installed"