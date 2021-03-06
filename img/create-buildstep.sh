#!/usr/bin/env bash

if [ ! -d "cloud-builders-community" ]; then
    git clone https://github.com/GoogleCloudPlatform/cloud-builders-community.git
    pushd cloud-builders-community/packer
else
    pushd cloud-builders-community
    git pull
    cd packer
fi

export PACKER_VERSION=$(curl -Ls https://releases.hashicorp.com/packer | grep packer | sed 's/.*>packer\(.*\)<.*/packer\1/g' | sort -r | uniq | head -n1 | cut -d'_' -f2)
export PACKER_VERSION_SHA256SUM=$(curl -Ls https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS | grep linux_amd64 | cut -d' ' -f1)

gcloud builds submit --substitutions=_PACKER_VERSION=${PACKER_VERSION},_PACKER_VERSION_SHA256SUM=${PACKER_VERSION_SHA256SUM} .

popd
