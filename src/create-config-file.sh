#!/bin/bash

if [[ ${DEVOPS_DIR} == "" ]]; then
    echo "[ERROR] This file should not be executed directly!"
    echo "[ERROR] It's a dependency of 'src/vars.sh'."
    exit 1
fi

if [[ -f ${DEVOPS_CONFIG_FILE} ]]; then
    echo "[ERROR] User's config file already exist:"
    echo "        ${DEVOPS_CONFIG_FILE}"
    exit 1
fi

# Create the new user's config file
echo "# Vault" >> ${DEVOPS_CONFIG_FILE}
echo "VAULT_ADDR=https://server-url:8080" >> ${DEVOPS_CONFIG_FILE}
echo "VAULT_KV_PATH=my-company/secrets" >> ${DEVOPS_CONFIG_FILE}
echo "VAULT_SECRET_NAME=main-infra" >> ${DEVOPS_CONFIG_FILE}
echo "VAULT_USERNAME=my.user.name" >> ${DEVOPS_CONFIG_FILE}
echo "VAULT_PASSWORD=myfuckingsecretpass" >> ${DEVOPS_CONFIG_FILE}
echo "" >> ${DEVOPS_CONFIG_FILE}

cat ${DEVOPS_DIR}/default-config.ini >> ${DEVOPS_CONFIG_FILE}
