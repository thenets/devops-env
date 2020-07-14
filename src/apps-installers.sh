#!/bin/bash

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/vars.sh

###
# Functions
###
install_python_lib(){
    LIB_NAME=$1
    
    # TODO change message when is a upgrading
    log_info "[python_venv] Upgrading '${LIB_NAME}' to the latest version..."
    . ${DEVOPS_PYTHON_ENV_DIR}/bin/activate 
    pip3 install ${LIB_NAME} -q
}

###
# TypeScript
###
install_typescript() {
    if [[ -z "$(command -v npm)" ]] ; then
        # npm not found
        sudo apt-get install -y npm
    fi

    if [[ -z "$(command -v tsc)" ]] ; then
        # typescript not found
        sudo npm install -g typescript
    fi
}

###
# Python Libs
##
install_python_pip() {
    install_python_lib "pip --upgrade"
}

install_python_awscli() {
    install_python_lib "awscli boto3 --upgrade"
}

install_python_ansible() {
    install_python_lib "ansible==${ANSIBLE_VERSION}"
}

install_python_cfn_lint() {
    install_python_lib "cfn-lint --upgrade"
}

install_python_troposphere() {
    install_python_lib "troposphere --upgrade"
    install_python_lib "troposphere[policy] --upgrade"
}

install_python_aws_adfs() {
    install_python_lib "aws-adfs --upgrade"
}

###
# Binaries
###
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

install_kubernetes_kubectl() {
    log_info "[kubernetes] Installing kubectl '${KUBECTL_VERSION}'..."
    wget -q -O ${DEVOPS_ENV_DIR}/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
    chmod +x ${DEVOPS_ENV_DIR}/bin/kubectl
}
install_kubernetes_aws_iam_authenticator() {
    log_info "[kubernetes] Installing aws-iam-authenticator '${AWS_IAM_AUTHENTICATOR}'..."
    wget -q -O ${DEVOPS_ENV_DIR}/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/${AWS_IAM_AUTHENTICATOR}/bin/linux/amd64/aws-iam-authenticator
    chmod +x ${DEVOPS_ENV_DIR}/bin/aws-iam-authenticator
}

# TODO not completed yet
install_saml2aws() {
    # project from https://github.com/Versent/saml2aws
    if [[ -f ${DEVOPS_ENV_DIR}/bin/saml2aws ]]; then
    	log_info "[saml2aws] Reinstalling saml2aws '${SAML2AWS_VERSION}'..."
	rm -f ${DEVOPS_ENV_DIR}/bin/saml2aws
    elif
    	log_info "[saml2aws] Installing saml2aws '${SAML2AWS_VERSION}'..."
    fi
	#wget -q -O ${DEVOPS_ENV_DIR}/bin/saml2aws.tar.gz https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VERSION}/saml2aws_${SAML2AWS_VERSION}_linux_amd64.tar.gz
    
    #tar -xzvf ${DEVOPS_ENV_DIR}/bin/saml2aws.tar.gz -C ${DEVOPS_ENV_DIR}/bin/ 1>/dev/null
    #rm -f ${DEVOPS_ENV_DIR}/bin/saml2aws.tar.gz
    
    # HACK custom build for SAML2AWS for Azure auth fix
    wget -q -O ${DEVOPS_ENV_DIR}/bin/saml2aws https://www.dropbox.com/s/vwklms0y1m6i8oa/saml2aws?dl=1
	chmod +x ${DEVOPS_ENV_DIR}/bin/saml2aws
}

# TODO not completed yet
install_terragrunt() {
    log_info "[terragrunt] Installing Terragrunt '${TERRAGRUNT_VERSION}'..."
    rm -f ${DEVOPS_ENV_DIR}/bin/terragrunt
	wget -q -O ${DEVOPS_ENV_DIR}/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64
	chmod +x ${DEVOPS_ENV_DIR}/bin/terragrunt
}

# TODO not completed yet
install_kubernetes_eksctl() {
    log_info "[kubernetes] Installing eksctl 'latest'..."
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C ${DEVOPS_ENV_DIR}/bin/
}
