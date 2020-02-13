#!/bin/bash

saml2aws_load_config() {
    CONFIG_FILE_PATH=$1
    PROFILE_NAME=${PROJECT_NAME}-${DEVOPS_ENV_NAME}

    # Load envs from *.<env>.saml2aws
    load_env_file ${CONFIG_FILE_PATH}

    # Configure - Cria o arquivo ~/.saml2aws
    export SAML2AWS_IDP_ACCOUNT=${PROFILE_NAME}
    export SAML2AWS_PROFILE=${PROFILE_NAME}
    export SAML2AWS_CONFIGFILE=${DEVOPS_ENV_DIR}/saml2aws.${DEVOPS_ENV_NAME}
    echo INICIO
    ${DEVOPS_ENV_DIR}/bin/saml2aws configure \
        --idp-account=${PROFILE_NAME} \
        --skip-prompt \
        --disable-keychain \
        1> /dev/null
    # TODO rename if file exist instead of delete it
    rm -f ~/.saml2aws
    ln -s ${DEVOPS_ENV_DIR}/saml2aws.${DEVOPS_ENV_NAME} ~/.saml2aws

    # Criar os arquivos ~/.aws/{config,credentials}
    unset AWS_PROFILE
    # aws configure set aws_access_key_id ${SAML2AWS_USERNAME} --profile ${PROFILE_NAME}
    # aws configure set aws_secret_access_key ${SAML2AWS_PASSWORD} --profile ${PROFILE_NAME}
    aws configure set region sa-east-1 --profile ${PROFILE_NAME} 

    # Login
    export AWS_ACCESS_KEY_ID=${SAML2AWS_USERNAME}
    export AWS_SECRET_ACCESS_KEY=${SAML2AWS_PASSWORD}
    ${DEVOPS_ENV_DIR}/bin/saml2aws login \
        --disable-keychain \
        --idp-account=${PROFILE_NAME}

    # TODO Unset all SAML2AWS envs
    unset SAML2AWS_VERSION
    unset SAML2AWS_AWS_URN
    unset SAML2AWS_MFA
    unset SAML2AWS_USERNAME
    unset SAML2AWS_IDP_ACCOUNT
    unset SAML2AWS_SESSION_DURATION
    unset SAML2AWS_ROLE
    unset SAML2AWS_PASSWORD
    unset SAML2AWS_CONFIGFILE
    unset SAML2AWS_PROFILE
    unset SAML2AWS_IDP_PROVIDER
    unset SAML2AWS_URL
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_DEFAULT_REGION

    # Switch AWS profile
    export AWS_PROFILE=${PROFILE_NAME}

    echo $CONFIG_FILE_PATH
}

# Disabled
saml2aws_aws_configure() {
    # Criar os arquivos ~/.aws/{config,credentials}
    aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID} --profile ${PROFILE_NAME} 
    aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY} --profile ${PROFILE_NAME} 
    aws configure set region sa-east-1 --profile ${PROFILE_NAME} 
}
