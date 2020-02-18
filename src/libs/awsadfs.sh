#!/bin/bash

awsadfs_load_config() {
    CONFIG_FILE_PATH=$1

    # Load envs from *.<env>.saml2aws
    load_env_file ${CONFIG_FILE_PATH}

    ENV_NAME=default
    AWSADFS_CONFIG_FILE_PATH=./aws.${ENV_NAME}.awsadfs
    AWSADFS_PROFILE_FULLNAME=${AWSADFS_PROFILE_NAME}-${ENV_NAME}

    # Create credentials tmp file
    TEMP_AUTH_FILE=$(mktemp)
    chmod 600 ${TEMP_AUTH_FILE}
    echo "[${AWSADFS_PROFILE_FULLNAME}-source]" > ${TEMP_AUTH_FILE}
    echo "username = ${AWSADFS_USER}" >> ${TEMP_AUTH_FILE}
    echo "password = ${AWSADFS_PASS}" >> ${TEMP_AUTH_FILE}

    # Create main account
    aws-adfs login \
        --profile=${AWSADFS_PROFILE_FULLNAME}-source \
        --adfs-host=${AWSADFS_HOST} \
        --authfile=${TEMP_AUTH_FILE}

    # Delete credentials tmp file
    rm -f ${TEMP_AUTH_FILE}

    # Create account equivalent to "Switch Account"
    # Criar os arquivos ~/.aws/{config,credentials}
    unset AWS_PROFILE
    aws configure set region ${AWSADFS_SWITCH_REGION} --profile ${AWSADFS_PROFILE_FULLNAME} && \
    aws configure set role ${AWSADFS_SWITCH_ROLE} --profile ${AWSADFS_PROFILE_FULLNAME} && \
    aws configure set source_credentials ${AWSADFS_PROFILE_FULLNAME}-source --profile ${AWSADFS_PROFILE_FULLNAME} && \
    aws configure set output json --profile ${AWSADFS_PROFILE_FULLNAME}

    # Switch AWS profile
    export AWS_PROFILE=${AWSADFS_PROFILE_FULLNAME}

    # Unset all AWSADFS envs
    unset AWSADFS_PROFILE_NAME
    unset AWSADFS_HOST
    unset AWSADFS_SWITCH_REGION
    unset AWSADFS_SWITCH_ROLE
    unset AWSADFS_USER
    unset AWSADFS_PASS
    unset AWSADFS_CONFIG_FILE_PATH

    echo ${CONFIG_FILE_PATH}
}


awsadfs_load() {
    if [[ -d ${DEVOPS_SECRETS_DIR} ]]; then
        if [[ "$(find ${DEVOPS_SECRETS_DIR} -name *.awsadfs -type f)" != "" ]]; then
            # Environment specific file
            for FILE in $(find ${DEVOPS_SECRETS_DIR} -name *.${DEVOPS_ENV_NAME}.awsadfs -type f); do
                FILENAME=$(realpath ${FILE} | rev | cut -d/ -f1 | rev)
                log "[awsadfs] secrets/${FILENAME}"
                awsadfs_load_config ${FILE}
            done
        fi
    fi
}