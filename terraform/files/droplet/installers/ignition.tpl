#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset

source ./installers/bootstrap.sh
source ./installers/grafana.sh

main(){
    # (Required)
    # Installing base dep packages
    install_base ${username}
    # Installing docker package
    install_docker ${username}
    # (Optional)
    # run_grafana $GRAFANA_ADMIN_PASS