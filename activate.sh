#!/bin/bash

if [[ ! $_ != $0 ]]; then
    source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/src/vars.sh
    log_error "[ERROR] DevOps env must be sourced! You should run:"
    log_error "        $ source ./devops/activate.sh"
    exit 1
fi

if [[ ${PS1} == "["*"|"*"]"* ]]; then
    log_warning "[devops_env] Already activated! Reloading..."
    deactivate
fi

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/src/vars.sh

set +e
set -o allexport

# Cleanup all AWS envs
unset $(awk 'BEGIN{for(v in ENVIRON) print v}' | grep ^AWS)

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

# Saml2aws Authentication
saml2aws_load

# AWSADFS Authentication
awsadfs_load

# Loads all envs from secrets
if [[ -d ${DEVOPS_SECRETS_DIR} ]]; then
    if [[ "$(find ${DEVOPS_SECRETS_DIR} -name *.env -type f)" != "" ]]; then
        # Environment specific file
        for FILE in $(find ${DEVOPS_SECRETS_DIR} -name *.${DEVOPS_ENV_NAME}.env -type f); do
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

# Add reactivate alias
alias reactivate="source ${DEVOPS_DIR}/activate.sh ${@}"

# Add binaries to the PATH
export PATH=${DEVOPS_ENV_DIR}/bin:${PATH}
export PATH=${DEVOPS_DIR}/bin:${PATH}

# Style for bash
BASH_ENV_PREFIX=$(echo "[\[${purple}\]${PROJECT_NAME}\[${reset}\] | \[${vivid_purple}\]${DEVOPS_ENV_NAME}\[${reset}\]]" )
export PS1="${BASH_ENV_PREFIX}"' \[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '
unset BASH_ENV_PREFIX

# Ansible settings
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_VAULT_SECRET_FILE=${DEVOPS_SECRETS_DIR}/ansible_vault_secret
alias ansible-playbook='ansible-playbook -i ${DEVOPS_ANSIBLE_DIR}/hosts.ini --vault-password-file ${ANSIBLE_VAULT_SECRET_FILE}'

# Do Hashicorp Vault login
source ${DEVOPS_SRC_DIR}/hashicorp_vault/get-token.sh

# Load custom plugins
if [[ -d "${DEVOPS_DIR}/plugins/activate/" ]]; then
    if [[ "$(ls -A ${DEVOPS_DIR}/plugins/activate/)" ]]; then
        source ${DEVOPS_DIR}/plugins/activate/*.sh
    fi
fi
if [[ -f "${DEVOPS_PLUGINS_DIR}/activate.sh" ]]; then
    source ${DEVOPS_PLUGINS_DIR}/activate.sh
fi

set +o allexport
