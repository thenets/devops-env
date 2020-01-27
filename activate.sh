#!/bin/bash

if [[ ${PS1} == "("*"|"*")"* ]]; then
    log_warning "[devops_env] Already activated!"
    log_warning "             Reactivating..."
    deactivate
fi

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/src/vars.sh

set +e
set -o allexport

# Check if .env dir does exist
if ! [[ -d ${DEVOPS_ENV_DIR} ]]; then
    log_error "[ERROR] DevOps env not initialized!"
    log_error "        You should run ./devops/install.sh"
    return
fi

# Get original PS1 before any change
ORIGINAL_PS1=${PS1}

# Loads Python virtualenv
source ${DEVOPS_PYTHON_ENV_DIR}/bin/activate

# Loads all envs from secrets
if [[ -d ${DEVOPS_SECRETS_DIR} ]]; then
    if [[ "$(find ${DEVOPS_SECRETS_DIR} -name *.env* -type f)" != "" ]]; then
        # Environment specific file
        for FILE in $(find ${DEVOPS_SECRETS_DIR} -name *.env.${DEVOPS_ENV_NAME} -type f); do
            load_env_file ${FILE}
            FILENAME=$(realpath ${FILE} | rev | cut -d/ -f1 | rev)
            log "[env_loaded] secrets/${FILENAME}"
        done

        # Generic env file
        for FILE in $(find ${DEVOPS_SECRETS_DIR} -name *.env -type f); do
            load_env_file ${FILE}
            FILENAME=$(realpath ${FILE} | rev | cut -d/ -f1 | rev)
            log "[env_loaded] secrets/${FILENAME}"
        done
    fi
fi

# Unset trash vars
unset FILENAME
unset FILE
unset FILES
unset LINE
unset LINES

# Add binaries to the PATH
export PATH=${PATH}:${DEVOPS_ENV_DIR}/bin
export PATH=${PATH}:${DEVOPS_DIR}/bin

# Style for bash
export PS1="(${purple}${PROJECT_NAME}${reset} | ${vivid_purple}${DEVOPS_ENV_NAME}${reset})"' \[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '
#export PS1="(DevOps) ${ORIGINAL_PS1}"

# Ansible settings
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_VAULT_SECRET_FILE=${DEVOPS_SECRETS_DIR}/ansible_vault_secret
alias ansible-playbook='ansible-playbook -i ${DEVOPS_ANSIBLE_DIR}/hosts.ini --vault-password-file ${ANSIBLE_VAULT_SECRET_FILE}'

# Do Hashicorp Vault login
# source ${DEVOPS_SRC_DIR}/hashicorp_vault/get-token.sh

set +o allexport
