#!/usr/bin/env bash

function packer-install() {
  OS=$(uname -s)
  [[ -f ${HOME}/bin/packer ]] && echo "`${HOME}/bin/packer version` already installed at ${HOME}/bin/packer" && return 0
  LATEST_URL=$(curl -sL https://releases.hashicorp.com/packer/index.json | jq -r '.versions[].version' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'alpha|beta|rc' | tail -1)
  LATEST_URL="https://releases.hashicorp.com/packer/${LATEST_VERSION}/packer_${LATEST_VERSION}_${OS}_amd64.zip"
  curl ${LATEST_URL} > /tmp/packer.zip
  mkdir -p ${HOME}/bin
  (cd ${HOME}/bin && unzip /tmp/packer.zip)
  if [[ -z $(grep 'export PATH=${HOME}/bin:${PATH}' ~/.bashrc 2>/dev/null) ]]; then
  	echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc
  fi
  
  echo "Installed: `${HOME}/bin/packer version`"
  
  cat - << EOF 
 
Run the following to reload your PATH with packer:

  source ~/.bashrc

EOF
}

packer-install