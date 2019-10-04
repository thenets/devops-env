#!/bin/bash

set -e

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/src/vars.sh

set -o allexport

# Check if .env dir does exist
if ! [[ -d ${DEVOPS_ENV_DIR} ]]; then
    log_error "[ERROR] DevOps env not initialized!"
    log_error "        You should run ./devops/install.sh"
    exit 1
fi

# Loads Python virtualenv
source ${DEVOPS_PYTHON_ENV_DIR}/bin/activate

# Loads all envs from secrets
if [[ -d ${DEVOPS_SECRETS_DIR} ]]; then
    for FILE in "${DEVOPS_SECRETS_DIR}"/*.env; do
        LINES=$(cat ${FILE} | sed 's/ //g')
        for LINE in ${LINES} ; do
            if ! [[ ${LINE} == *"#"* ]] && [[ ${LINE} == *"="* ]]; then
                export ${LINE}
            fi
        done
    done
fi

# Add binaries to the PATH
export PATH=${PATH}:${DEVOPS_ENV_DIR}/bin
export PATH=${PATH}:${DEVOPS_DIR}/bin

# Style for bash
export PS1='(DevOps) \[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '

# Ansible settings
export ANSIBLE_HOST_KEY_CHECKING=False
export DEFAULT_VAULT_PASSWORD_FILE=${DEVOPS_SECRETS_DIR}/ansible_vault_secret
alias ansible-playbook='ansible-playbook -i ${DEVOPS_DIR}/ansible/hosts.ini --vault-password-file ${DEFAULT_VAULT_PASSWORD_FILE}'

# # Do Vault login
# unset VAULT_TOKEN
# export VAULT_TOKEN=$(vault login -no-store -method=userpass username=${VAULT_USERNAME} password=${VAULT_PASSWORD} -format=json 2>/dev/null | jq '.auth.client_token' -r)
# ${DIR}/setup-vault.sh

# # Vault settings
# alias vault-secrets-download="${DIR}/vault-secrets-download.sh"
# alias vault-secrets-upload="${DIR}/vault-secrets-upload.sh"

set +o allexport
