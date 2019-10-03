# DevOps Environment

## How to install

```bash
# Create your project dir
mkdir my-project
cd my-project

# Clone
git clone https://github.com/thenets/devops-env.git devops
```

## How to update

```bash
./devops/update.sh
```

## Add to your .gitignore

```
config
.env/
secrets/
```

## Config file example

```ini
# Vault
VAULT_ADDR=https://server-url:8080
VAULT_KV_PATH=my-company/secrets
VAULT_SECRET_NAME=main-infra
VAULT_USERNAME=my.user.name
VAULT_PASSWORD=myfuckingsecretpass

# Apps versions
TERRAFORM_VERSION=0.10.8
ANSIBLE_VERSION=2.7.11
```
