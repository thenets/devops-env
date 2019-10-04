#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Load root config file
ROOT_CONFIG_FILE=${DIR}/../config
if test -f "$ROOT_CONFIG_FILE"; then
    source ${ROOT_CONFIG_FILE}
fi

# Check empty variables
if [ -z "$VAULT_ADDR" ]; then
    echo "[ERROR] The variable VAULT_ADDR must be declared!"
    exit 1
fi


if [ -z "$VAULT_KV_PATH" ]; then
    echo "[ERROR] The variable VAULT_KV_PATH must be declared!"
    exit 1
fi


if [ -z "$VAULT_USERNAME" ]; then
    echo "[ERROR] The variable VAULT_USERNAME must be declared!"
    exit 1
fi


if [ -z "$VAULT_PASSWORD" ]; then
    echo "[ERROR] The variable VAULT_PASSWORD must be declared!"
    exit 1
fi

