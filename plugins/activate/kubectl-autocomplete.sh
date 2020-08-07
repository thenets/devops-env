#!/bin/bash

if [[ -f "/usr/share/bash-completion/bash_completion" ]]; then
    source /usr/share/bash-completion/bash_completion
fi

if [[ -f "${DEVOPS_ENV_DIR}/bin/kubectl" ]]; then
    source <(${DEVOPS_ENV_DIR}/bin/kubectl completion bash)
fi
