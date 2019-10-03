#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ENV_DIR=${DIR}/../.env

TERRAFORM_DIR=${DIR}/../terraform
PROJECT_DIR=${DIR}/..

# Touch config file
touch ${ENV_DIR}/config/terraform.env
