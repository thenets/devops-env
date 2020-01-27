#!/bin/bash

# Based on:
# https://github.com/containers/Demos/blob/master/building/buildah_intro/buildah_intro.sh

# Setting up some colors for helping read the demo output.
# Comment out any of the below to turn off that color.
if [[ ${TERM} != "dumb" ]]; then
    bold=$(tput bold)
    reset=$(tput sgr0)

    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    blue=$(tput setaf 4)
    purple=$(tput setaf 5)
    cyan=$(tput setaf 6)
    white=$(tput setaf 7)
    grey=$(tput setaf 8)
    vivid_red=$(tput setaf 9)
    vivid_green=$(tput setaf 10)
    vivid_yellow=$(tput setaf 11)
    vivid_blue=$(tput setaf 12)
    vivid_purple=$(tput setaf 13)
    vivid_cyan=$(tput setaf 14)
fi

log() {
    if [[ $1 == *"["*"]"* ]]; then
        out=$(echo $1 | sed "s/]/]${reset}/g")
        echo "${bold}$out${reset}"
    else
        echo "${bold}$1${reset}"
    fi
}

log_bold() {
    echo "${bold}$1${reset}"
}

log_info() {
    if [[ $1 == *"["*"]"* ]]; then
        out=$(echo $1 | sed "s/]/]${reset}/g")
        echo "${vivid_purple}$out${reset}"
    else
        echo "${cyan}$1${reset}"
    fi
}

log_warning() {
    echo "${vivid_yellow}$1${reset}"
}

log_error() {
    echo "${vivid_red}$1${reset}"
}
