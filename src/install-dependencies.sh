#!/bin/bash

# Dependencies
COMMANDS_REQUIRED="curl wget zip unzip jq python3 virtualenv crudini awk make bash"
PACKAGES_UBUNTU="curl wget zip unzip jq python3 virtualenv crudini gawk make bash"

# Check if all commands do exist
INSTALLATION_REQUIRED="false"
for __command in ${COMMANDS_REQUIRED}
do
    if ! command_loc="$(type -p "$__command")" || [[ -z $command_loc ]]; then
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
	${SUDO} apt-get update -qq
	${SUDO} apt-get install -qq -y ${PACKAGES_UBUNTU}
fi
