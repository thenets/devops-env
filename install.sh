#!/bin/bash

set -e

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/src/vars.sh

log_info "# Starting DevOps env installation process"

# Install dependencies
${DEVOPS_SRC_DIR}/install-os-dependencies.sh

# Create Python Virtual Environment and activate it
if ! [[ -f ${DEVOPS_PYTHON_ENV_DIR}/bin/activate ]]; then
    log_info "[python_venv] Creating Python virtualenv..."
    virtualenv -p python3 ${DEVOPS_PYTHON_ENV_DIR}
else
    log_info "[python_venv] Python virtualenv detected. Skipping installation."
fi

# Installers apps
source ${DEVOPS_SRC_DIR}/apps-installers.sh
install_typescript
install_python_pip
install_python_awscli
install_python_ansible
install_python_cfn_lint
install_python_troposphere
install_python_aws_adfs
install_hashicorp_terraform
install_hashicorp_vault
install_saml2aws
install_kubernetes_kubectl
install_kubernetes_aws_iam_authenticator
install_kubernetes_eksctl

# install_hashicorp_vagrant
# install_terragrunt

# Create dirs
log_info "[devops_env] Creating project dirs if not exist..."
mkdir -p ${DEVOPS_PROJECT_DIR}/secrets

${DEVOPS_SRC_DIR}/update-gitignore.sh

log_info "# Installation complete"
