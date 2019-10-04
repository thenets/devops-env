#!/bin/bash

set -e

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/src/vars.sh

# Fix permissions
chmod +x  ${DEVOPS_DIR}/*.sh
chmod +x  ${DEVOPS_DIR}/src/*.sh

log_info "# Starting DevOps env installation process"

# Install dependencies
${DEVOPS_SRC_DIR}/install-dependencies.sh

exit

# Create Python Virtual Environment
# and activate it
virtualenv -p python3 ${PYTHON_ENV_DIR}
. ${PYTHON_ENV_DIR}/bin/activate 

##
# Installers apps
##

# Install Terraform 
mkdir -p ${ENV_DIR}/bin
wget -O ${ENV_DIR}/bin/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
cd ${ENV_DIR}/bin && unzip -o ./terraform.zip
rm ${ENV_DIR}/bin/terraform.zip
chmod +x ${ENV_DIR}/bin/terraform
@echo "\n# Hashicorp Terraform installed!\n"

# Install Hashicorp Vault
mkdir -p ${ENV_DIR}/bin
wget -O ${ENV_DIR}/bin/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
cd ${ENV_DIR}/bin && unzip -o ./vault.zip
rm ${ENV_DIR}/bin/vault.zip
chmod +x ${ENV_DIR}/bin/vault
@echo "\n# Hashicorp Vault installed!\n"

# Install Hashicorp Vagrant
mkdir -p ${ENV_DIR}/bin
wget -O ${ENV_DIR}/bin/vagrant.zip https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_linux_amd64.zip
cd ${ENV_DIR}/bin && unzip -o ./vagrant.zip
rm ${ENV_DIR}/bin/vagrant.zip
chmod +x ${ENV_DIR}/bin/vagrant
@echo "\n# Hashicorp Vagrant installed!\n"

# Install AWS CLI
pip3 install awscli --upgrade

# Install Ansible
pip install ansible==${ANSIBLE_VERSION}
