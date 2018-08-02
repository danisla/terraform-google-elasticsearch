#!/bin/bash

ws_input=$1

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function red() {
    printf "${RED}$1${NC}\n"
}

function green() {
    printf "${GREEN}$1${NC}\n"
}

[[ -z "${GOOGLE_PROJECT}" ]] && export GOOGLE_PROJECT=$(gcloud config get-value project)

CURR_DIR=$(basename "$PWD")
PARENT_DIR=$(basename "$(dirname "$PWD")")

cat > backend.tf <<EOF
terraform {
  backend "gcs" {
    bucket = "concourse-terraform-remote-backend"
    prefix = "terraform-google-elasticsearch"
  }
}
EOF

terraform init >/dev/null

function isStateEmpty() {
    terraform workspace select -no-color $1 >/dev/null
    terraform state pull >/dev/null
    [[ "$(terraform state list | wc -l)" -le 1 ]]
}

function cleanWorkspace() {
    local ws=$1
    echo "INFO: Checking workspace: $ws"
    if isStateEmpty $ws; then 
        green "INFO: $ws is clean"
    else
        red "WARN: $ws is not clean, destroying resources"
        terraform destroy -auto-approve
    fi
}

for ws in $(terraform workspace list | sed 's/[ *]//g'); do
    [[ -n "${ws_input}" && "$ws" != "${ws_input}" ]] && continue
    [[ "$ws" == "default" ]] && continue
    [[ "$ws" =~ -infra && "${PARENT_DIR}" != "infra" ]] && continue
    [[ ! "$ws" =~ -infra && "${PARENT_DIR}" != "examples" ]] && continue

    # if [[ "${PARENT_DIR}" == "infra" && "$ws" =~ -infra ]]; then
    #     ### Infra cleanup ###
        
    #     case $ws in
    #     esac
    # fi
    
    if [[ "${PARENT_DIR}" == "examples" && ! "$ws" =~ -infra ]]; then
        ### Example cleanup ###

        case $ws in
        tf-ci-es-single-node*)
            [[ "${CURR_DIR}" == "single-node" ]] && cleanWorkspace $ws
            continue
            ;;
        esac
    fi
done
