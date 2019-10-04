#!/bin/bash

set -e

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/src/vars.sh

# Fix permissions
chmod +x  ${DEVOPS_DIR}/*.sh
chmod +x  ${DEVOPS_DIR}/src/*.sh

log_info "# Starting DevOps env installation process"

# Install dependencies
${DEVOPS_SRC_DIR}/install-dependencies.sh

# Create Python Virtual Environment
# and activate it
if ! [[ -f ${DEVOPS_PYTHON_ENV_DIR}/bin/activate ]]; then
    log_info "[python_venv] Creating Python virtualenv..."
    virtualenv -p python3 ${DEVOPS_PYTHON_ENV_DIR}
else
    log_info "[python_venv] Python virtualenv already detected"
fi

##
# Installers apps
##

log_info "[python_venv] Activating..."
. ${DEVOPS_PYTHON_ENV_DIR}/bin/activate 

# Install AWS CLI
log_info "[python_venv] Installing or updating 'awscli' to the latest version..."
pip3 install awscli --upgrade -q

# Install Ansible
log_info "[python_venv] Installing or updating 'ansible' to '${ANSIBLE_VERSION}'..."
pip install ansible==${ANSIBLE_VERSION} -q


# Install Terraform
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

# Install Hashicorp Vault
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

# Install Hashicorp Vagrant
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

log_info "# Installation completed"