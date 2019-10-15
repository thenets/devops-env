#!/bin/bash

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/vars.sh

install_pip() {
    log_info "[python_venv] Upgrading 'pip' to the latest version..."
    . ${DEVOPS_PYTHON_ENV_DIR}/bin/activate 
    pip3 install pip --upgrade -q
}

install_python_awscli() {
    log_info "[python_venv] Installing or upgrading 'awscli' to the latest version..."
    . ${DEVOPS_PYTHON_ENV_DIR}/bin/activate 
    pip3 install awscli --upgrade -q
}

install_python_ansible() {
    log_info "[python_venv] Installing or upgrading 'ansible' to '${ANSIBLE_VERSION}'..."
    . ${DEVOPS_PYTHON_ENV_DIR}/bin/activate 
    pip install ansible==${ANSIBLE_VERSION} -q
}

install_hashicorp_terraform() {
    if [[ -f ${DEVOPS_ENV_DIR}/bin/terraform ]]; then
        current_version=$(${DEVOPS_ENV_DIR}/bin/terraform -v | head -n 1 | sed 's/Terraform v//g')
        if [[ ${current_version} != ${TERRAFORM_VERSION} ]]; then
            log_info "[hashicorp] Mismatching Terraform version. Removing version '${current_version}' to install '${TERRAFORM_VERSION}'"
            rm -f ${DEVOPS_ENV_DIR}/bin/terraform
        fi
    fi
    if [[ -f ${DEVOPS_ENV_DIR}/bin/terraform ]]; then
        log_info "[hashicorp] Terraform already installed"
    else
        log_info "[hashicorp] Installing Terraform '${TERRAFORM_VERSION}'..."
        mkdir -p ${DEVOPS_ENV_DIR}/bin
        wget -q -O ${DEVOPS_ENV_DIR}/bin/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
        cd ${DEVOPS_ENV_DIR}/bin && unzip -q -o ./terraform.zip
        rm ${DEVOPS_ENV_DIR}/bin/terraform.zip
        chmod +x ${DEVOPS_ENV_DIR}/bin/terraform
    fi
}

install_hashicorp_vault() {
    if [[ -f ${DEVOPS_ENV_DIR}/bin/vault ]]; then
        current_version=$(${DEVOPS_ENV_DIR}/bin/vault -v | head -n 1 | sed 's/Vault v//g' | awk -F ' ' '{printf $1}')
        if [[ ${current_version} != ${VAULT_VERSION} ]]; then
            log_info "[hashicorp] Mismatching Vault version. Removing version '${current_version}' to install '${VAULT_VERSION}'"
            rm -f ${DEVOPS_ENV_DIR}/bin/vault
        fi
    fi
    if [[ -f ${DEVOPS_ENV_DIR}/bin/vault ]]; then
        log_info "[hashicorp] Vault already installed"
    else
        log_info "[hashicorp] Installing Vault '${VAULT_VERSION}'..."
        mkdir -p ${DEVOPS_ENV_DIR}/bin
        wget -q -O ${DEVOPS_ENV_DIR}/bin/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
        cd ${DEVOPS_ENV_DIR}/bin && unzip -q -o ./vault.zip
        rm ${DEVOPS_ENV_DIR}/bin/vault.zip
        chmod +x ${DEVOPS_ENV_DIR}/bin/vault
    fi
}

install_hashicorp_vagrant() {
    if [[ -f ${DEVOPS_ENV_DIR}/bin/vagrant ]]; then
        current_version=$(${DEVOPS_ENV_DIR}/bin/vagrant -v | head -n 1 | sed 's/Vagrant v//g')
        if [[ ${current_version} != ${VAGRANT_VERSION} ]]; then
            log_info "[hashicorp] Mismatching Vagrant version. Removing version '${current_version}' to install '${VAGRANT_VERSION}'"
            rm -f ${DEVOPS_ENV_DIR}/bin/vagrant
        fi
    fi
    if [[ -f ${DEVOPS_ENV_DIR}/bin/vagrant ]]; then
        log_info "[hashicorp] Vagrant already installed"
    else
        log_info "[hashicorp] Installing Vagrant '${VAGRANT_VERSION}'..."
        mkdir -p ${DEVOPS_ENV_DIR}/bin
        wget -q -O ${DEVOPS_ENV_DIR}/bin/vagrant.zip https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_linux_amd64.zip
        cd ${DEVOPS_ENV_DIR}/bin && unzip -q -o ./vagrant.zip
        rm ${DEVOPS_ENV_DIR}/bin/vagrant.zip
        chmod +x ${DEVOPS_ENV_DIR}/bin/vagrant
    fi
}

# TODO not completed yet
install_terragrunt() {
    log_info "[terragrunt] Installing Terragrunt '${TERRAGRUNT_VERSION}'..."
    rm -f ${DEVOPS_ENV_DIR}/bin/terragrunt
	wget -q -O ${DEVOPS_ENV_DIR}/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64
	chmod +x ${DEVOPS_ENV_DIR}/bin/terragrunt
}