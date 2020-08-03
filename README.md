# DevOps Environment

A toolset to work with cloud environment.

[![asciicast](./docs/preview.svg)](https://asciinema.org/a/sShTBvpzo9yohonEGsEKr6HC1)

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
./devops/update.sh
```

## Install tools

You can check all tools available:

```bash
# Enable DevOps env
source devops/activate.sh

# List installers
devops install-list
```

Than install the tools that you need:

```bash
# Enable DevOps env
source devops/activate.sh

# Install Hashicorp Terraform
devops install hashicorp_terraform

# Install AWS CLI
devops install awscli
```

## Add to your .gitignore

The `./.gitignore` will be verified during the installation process. If some line is missing it will be appended in the end.

## Config file example

The `./config.ini` will be generated during the first installation process if not exist.
