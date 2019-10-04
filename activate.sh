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
exit
# Loads Python virtualenv
source ${DEVOPS_PYTHON_ENV_DIR}/bin/activate

# Loads all envs from secrets
mkdir -p ${DEVOPS_SECRETS_DIR}
for file_path in "${DEVOPS_SECRETS_DIR}"/* ; do
    # Check if is a regular file
    if [ -f $file_path ]; then
        FILE_NAME=$(echo "$file_path" | awk -F/ '{print $NF}')
        if [[ $FILE_NAME == *".env" ]]; then
            source ${file_path}
        fi
    fi
done

# Loads root config file
ROOT_CONFIG_FILE=${DIR}/../config
if test -f "$ROOT_CONFIG_FILE"; then
    source ${ROOT_CONFIG_FILE}
fi

# Add binaries to the PATH
export PATH=${PATH}:${DEVOPS_ENV_DIR}/bin

# Add custom envs to the bash context
if test -f "${DEVOPS_SECRETS_DIR}/devops.env"; then
    source ${DEVOPS_SECRETS_DIR}/devops.env
fi

# Do Vault login
unset VAULT_TOKEN
export VAULT_TOKEN=$(vault login -no-store -method=userpass username=${VAULT_USERNAME} password=${VAULT_PASSWORD} -format=json 2>/dev/null | jq '.auth.client_token' -r)
${DIR}/setup-vault.sh

# Style for bash
export PS1='(DevOps) \[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '

# Ansible settings
export ANSIBLE_HOST_KEY_CHECKING=False
export DEFAULT_VAULT_PASSWORD_FILE=${DEVOPS_SECRETS_DIR}/ansible_vault_secret
alias ansible-playbook='ansible-playbook -i ${DIR}/ansible/hosts.ini --vault-password-file ${DEFAULT_VAULT_PASSWORD_FILE}'

# Vault settings
alias vault-secrets-download="${DIR}/vault-secrets-download.sh"
alias vault-secrets-upload="${DIR}/vault-secrets-upload.sh"

set +o allexport
