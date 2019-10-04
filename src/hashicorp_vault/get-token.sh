#!/bin/bash

if [[ ${DEVOPS_DIR} == "" ]]; then
    echo "[ERROR] This file should not be executed directly!"
    exit 1
fi

if [[ ${VAULT_ADDR} != "https://server-url:8080" ]] && [[ ${VAULT_ADDR} != "" ]]; then
    unset VAULT_TOKEN
    export VAULT_TOKEN=$(${DEVOPS_ENV_DIR}/bin/vault login -no-store -method=userpass username=${VAULT_USERNAME} password=${VAULT_PASSWORD} -format=json 2>/dev/null | jq '.auth.client_token' -r)
fi
