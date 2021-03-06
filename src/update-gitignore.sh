#!/bin/bash

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/vars.sh

log_info "[devops_env] Updating .gitignore file"

# Check if .gitignore has \n in the tail
if [[ -f ${DEVOPS_PROJECT_DIR}/.gitignore ]]; then
    if ! [[ -z "$(tail -c 1 ${DEVOPS_PROJECT_DIR}/.gitignore)" ]]; then
        echo "" >> ${DEVOPS_PROJECT_DIR}/.gitignore
    fi
fi

# Add new items to .gitignore file
FILES_TO_IGNORE=$(echo "config.ini .env/ secrets/ .terraform/ *.retry" | sed 's/ /\n/g')
if [[ -f ${DEVOPS_PROJECT_DIR}/.gitignore ]]; then
    for FILE in ${FILES_TO_IGNORE}; do
        if ! grep -Fxq "${FILE}" ${DEVOPS_PROJECT_DIR}/.gitignore; then
            echo "${FILE}" >> ${DEVOPS_PROJECT_DIR}/.gitignore
        fi
    done
else
    echo "${FILES_TO_IGNORE}" >> ${DEVOPS_PROJECT_DIR}/.gitignore
fi
