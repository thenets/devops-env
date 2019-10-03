#!/bin/bash

export DEVOPS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ >/dev/null 2>&1 && pwd )
export DEVOPS_SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

# Vars
export DEVOPS_ENV_DIR=${DEVOPS_DIR}/../.env
export DEVOPS_ANSIBLE_DIR=${DEVOPS_DIR}/../ansible
export DEVOPS_PROJECT_DIR=${DEVOPS_DIR}/..
export DEVOPS_SECRETS_DIR=${DEVOPS_PROJECT_DIR}/secrets
export DEVOPS_PYTHON_ENV_DIR=${DEVOPS_ENV_DIR}/python_env

# Import default config vars
export $(shell sed 's/=.*//' ${DEVOPS_DIR}/default-config.ini)

# Import libs
source ${DEVOPS_SRC_DIR}/lib-color.sh
