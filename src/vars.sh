#!/bin/bash

export DEVOPS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ >/dev/null 2>&1 && pwd )
export DEVOPS_SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

# Vars
export DEVOPS_ENV_DIR=${DEVOPS_DIR}/../.env
export DEVOPS_ANSIBLE_DIR=${DEVOPS_DIR}/../ansible
export DEVOPS_PROJECT_DIR=${DEVOPS_DIR}/..
export DEVOPS_SECRETS_DIR=${DEVOPS_PROJECT_DIR}/secrets
export DEVOPS_PYTHON_ENV_DIR=${DEVOPS_ENV_DIR}/python_env
export DEVOPS_CONFIG_FILE=${DEVOPS_PROJECT_DIR}/config.ini

# Import libs
source ${DEVOPS_SRC_DIR}/lib-logs.sh

# Import default config vars
LINES=$(cat ${DEVOPS_DIR}/default-config.ini | sed 's/ //g')
for LINE in ${LINES} ; do
    if ! [[ ${LINE} == *"#"* ]] && [[ ${LINE} == *"="* ]]; then
        export ${LINE}
    fi
done

# Import user's config file
if [[ -f ${DEVOPS_CONFIG_FILE} ]]; then
    LINES=$(cat ${DEVOPS_CONFIG_FILE} | sed 's/ //g')
    for LINE in ${LINES} ; do
        if ! [[ ${LINE} == *"#"* ]] && [[ ${LINE} == *"="* ]]; then
            export ${LINE}
        fi
    done
else
    log_warning "[config] User's config file not found. Creating a new one..."
    ${DEVOPS_SRC_DIR}/create-config-file.sh
fi
