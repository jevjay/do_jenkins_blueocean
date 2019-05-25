#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset

install_base(){
    echo "Updating repositories and installing base packages"
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common vim
}

install_docker(){
    local username=$1

    if test -z "$username" 
    then
      echo "\$username is not set. Aborting..."
      exit 1
    fi
}


