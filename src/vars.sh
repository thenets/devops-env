#!/bin/bash

export DEVOPS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ >/dev/null 2>&1 && pwd )
export DEVOPS_SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

# Static vars
export DEVOPS_ENV_DIR=${DEVOPS_DIR}/../.env
export DEVOPS_ANSIBLE_DIR=${DEVOPS_DIR}/../ansible
export DEVOPS_PROJECT_DIR=${DEVOPS_DIR}/..
export DEVOPS_SECRETS_DIR=${DEVOPS_PROJECT_DIR}/secrets
export DEVOPS_PYTHON_ENV_DIR=${DEVOPS_ENV_DIR}/python_env
export DEVOPS_CONFIG_FILE=${DEVOPS_PROJECT_DIR}/config.ini
export DEVOPS_VERSIONS_FILE=${DEVOPS_PROJECT_DIR}/versions.ini

# Dynamic vars
export PROJECT_NAME=$(realpath ${DEVOPS_PROJECT_DIR} | rev | cut -d/ -f1 | rev)
if [[ -z $1 ]]; then
    export DEVOPS_ENV_NAME=default
else
    export DEVOPS_ENV_NAME=$1
fi

# Import libs
if [[ -d ${DEVOPS_SRC_DIR}/libs/ ]]; then
    if [[ "$(find ${DEVOPS_SRC_DIR}/libs/ -name *.sh -type f)" != "" ]]; then
        for FILE in $(find ${DEVOPS_SRC_DIR}/libs/ -name *.sh -type f); do
            source ${FILE}
        done
    fi
fi

# Import default versions vars
LINES=$(cat ${DEVOPS_DIR}/default-versions.ini | sed 's/ //g')
for LINE in ${LINES} ; do
    if ! [[ ${LINE} == *"#"* ]] && [[ ${LINE} == *"="* ]]; then
        export ${LINE}
    fi
done

# Import user's versions file
if [[ -f ${DEVOPS_VERSIONS_FILE} ]]; then
    load_env_file ${DEVOPS_VERSIONS_FILE}
else
    log_warning "[config] User's versions file not found. Creating a new one..."
    cat ${DEVOPS_DIR}/default-versions.ini >> ${DEVOPS_VERSIONS_FILE}
fi

# Import user's config file
if [[ -f ${DEVOPS_CONFIG_FILE} ]]; then
    load_env_file ${DEVOPS_CONFIG_FILE}
else
    log_warning "[config] User's config file not found. Creating a new one..."
    ${DEVOPS_SRC_DIR}/create-config-file.sh
fi
