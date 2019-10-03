#!/bin/bash

set -e

# Vars
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ENV_DIR=${DIR}/../.env
TERRAFORM_DIR=${DIR}/../terraform
ANSIBLE_DIR=${DIR}/../ansible
PROJECT_DIR=${DIR}/..
SECRETS_DIR=${PROJECT_DIR}/secrets

# Enable DevOps env
. ${DIR}/activate.sh

# Enter in Terraform dir
cd ${TERRAFORM_DIR}

# For each file in 'SECRETS_DIR'
TERRAFORM_ARGS=''
for file_path in "${SECRETS_DIR}"/* ; do
    # Check if is a regular file
    if [ -f $file_path ]; then
        FILE_NAME=$(echo "$file_path" | awk -F/ '{print $NF}')
        TERRAFORM_ARGS=${TERRAFORM_ARGS}" ${FILE_NAME}=@${SECRETS_DIR}/${FILE_NAME}"
    fi
done

# Add terraform.tfstate (special file)
if [ -f ${TERRAFORM_DIR}/terraform.tfstate ]; then
    TERRAFORM_ARGS=${TERRAFORM_ARGS}" terraform.tfstate=@${TERRAFORM_DIR}/terraform.tfstate"
fi

# Upload all files to the Vault
vault kv put ${VAULT_KV_PATH}/${VAULT_SECRET_NAME} ${TERRAFORM_ARGS}
