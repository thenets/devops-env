# DevOps Environment

A toolset to work with cloud environment.

## What's included?

Binaries:

- Ansible
- Hashicorp Terraform
- Hashocorp Vault
- AWS CLI

Features:

- Simple way to share secrets with ops team using Hashicorp Vault.

## How to install

```bash
# Create your project dir
mkdir my-project
cd my-project

# Clone
git clone https://github.com/thenets/devops-env.git devops

# Start the installation script
./devops/install.sh
```

## How to update

```bash
./devops/bin/devops-env-update
```

## Add to your .gitignore

The `./.gitignore` will be verified during the installation process. If some line is missing it will be appended in the end.

## Config file example

The `./config.ini` will be generated during the first installation process if not exist.
