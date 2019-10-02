#!/bin/bash

# Vars
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ENV_DIR=${DIR}/../.env
TERRAFORM_DIR=${DIR}/../terraform
ANSIBLE_DIR=${DIR}/../ansible
PROJECT_DIR=${DIR}/..
TERRAFORM_CONFIG_FILE=${ENV_DIR}/config/terraform.env
SECRETS_DIR=${PROJECT_DIR}/secrets

# Remove old files
rm -rf ${SECRETS_DIR}
mkdir -p ${SECRETS_DIR}
rm -f ${TERRAFORM_CONFIG_FILE}
touch ${TERRAFORM_CONFIG_FILE}

set -e

# Enable DevOps env
. ${DIR}/activate.sh

# Get files from Vault
FILES=$(${ENV_DIR}/bin/vault kv get -format=json ${VAULT_KV_PATH}/${VAULT_SECRET_NAME}/ | jq '.data.data')

# Main vars
NUMBER_OF_FILES=$(echo ${FILES} | jq 'length')
FILE_NAMES=$(echo ${FILES} | jq 'keys')

# For each file
for i in $(seq $NUMBER_OF_FILES); do
    index=($i-1)
    FILE_NAME=$(echo ${FILE_NAMES} | jq -r ".[${index}]")
    FILE_CONTENT_ENCODED=$(echo "${FILES}" | jq -r ".\"${FILE_NAME}\" | @base64")

    # If terraform.tfstate
    if [ "$FILE_NAME" == "terraform.tfstate" ]; then
        echo "${FILE_CONTENT_ENCODED}" | base64 --decode > ${TERRAFORM_DIR}/${FILE_NAME}

    # Other files
    else
        echo "${FILE_CONTENT_ENCODED}" | base64 --decode > ${SECRETS_DIR}/${FILE_NAME}
    fi
done

# Set permissions
chmod 600 ${SECRETS_DIR}/*

# DEBUG
#echo '# NUMBER_OF_FILES '${NUMBER_OF_FILES}
