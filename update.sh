#!/bin/bash

set -e

# Vars
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ENV_DIR=${DIR}/../.env
TERRAFORM_DIR=${DIR}/../terraform
ANSIBLE_DIR=${DIR}/../ansible
PROJECT_DIR=${DIR}/..
SECRETS_DIR=${PROJECT_DIR}/secrets

cd ${DIR}/scripts
git pull origin master
