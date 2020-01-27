#!/bin/bash

# function load_env_file
# @param <EnvironmentFile>
load_env_file() {
    FILE=$1

    # Check if all .env in secrets has \n in the tail
    if ! [[ -z "$(tail -c 1 ${FILE})" ]]; then
        echo "" >> ${FILE}
    fi

    # Load all env file lines
    LINES=$(cat ${FILE} | sed 's/ //g')
    for LINE in ${LINES} ; do
        if ! [[ ${LINE} == *"#"* ]] && [[ ${LINE} == *"="* ]]; then
            export "${LINE}"
        fi
    done
}
