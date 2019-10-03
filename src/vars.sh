#!/bin/bash

DEVOPS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"/../ )" >/dev/null 2>&1 && pwd )"
DEVOPS_SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Vars
DEVOPS_ENV_DIR=${DEVOPS_DIR}/../.env
DEVOPS_ANSIBLE_DIR=${DEVOPS_DIR}/../ansible
DEVOPS_PROJECT_DIR=${DEVOPS_DIR}/..
DEVOPS_SECRETS_DIR=${DEVOPS_PROJECT_DIR}/secrets
DEVOPS_PYTHON_ENV_DIR=${DEVOPS_ENV_DIR}/python_env

# Import default config vars
source ${DEVOPS_DIR}/src/default-config
