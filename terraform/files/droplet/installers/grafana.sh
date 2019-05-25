#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset

run_grafana(){
  local admin_pass=$1

  if test -z "$admin_pass" 
    then
      echo "\$admin_pass is not set. Aborting..."
      exit 1
  fi

  echo "Run docker container"
  docker run \
    -d \
    -p 3000:3000 \
    --name=grafana \
    -e "GF_SECURITY_ADMIN_PASSWORD=$admin_pass" \
    grafana/grafana
}
