#!/usr/bin/env bash

PROJECT_NUMBER=$(gcloud projects describe $(gcloud config get-value core/project) --format="value(projectNumber)")

if [ "X$(gcloud projects get-iam-policy $PROJECT_NUMBER --flatten=bindings --filter='bindings.role:roles/cloudkms.cryptoKeyDecrypter' --format='value(bindings.members)')" == "X" ]; then
  CLOUD_BUILD_SERVICE_ACCOUNT=$(gcloud projects get-iam-policy $PROJECT_NUMBER --format "value(bindings.members)" | tr ';' '\n' | grep '@cloudbuild' | head -n1 | cut -d"'" -f2)
  gcloud projects add-iam-policy-binding $PROJECT_NUMBER --member=${CLOUD_BUILD_SERVICE_ACCOUNT} --role=roles/cloudkms.cryptoKeyDecrypter
fi

if [ "X$(gcloud iam service-accounts list --filter='email ~ image-builder' --format='value(email)')" == "X" ]; then
    gcloud iam service-accounts create image-builder
fi

IMAGE_BUILDER_SERVICE_ACCOUNT=$(gcloud iam service-accounts list --filter="email ~ image-builder" --format="value(email)")
gcloud iam service-accounts keys create image-builder.key --iam-account=${IMAGE_BUILDER_SERVICE_ACCOUNT}
gcloud projects add-iam-policy-binding $PROJECT_NUMBER --member=serviceAccount:${IMAGE_BUILDER_SERVICE_ACCOUNT} --role=roles/editor

if [ "X$(gcloud kms keyrings list --location=global --filter='name ~ packer' --format='value(name)')" == "X" ]; then
  gcloud kms keyrings create packer --location=global
  gcloud kms keys create pk --keyring=packer --location=global --purpose=encryption
fi

gcloud kms encrypt --keyring=packer --key=pk --location=global --plaintext-file=image-builder.key --ciphertext-file=image-builder-enc.key
