#!/usr/bin/env bash

unset zone
unset gpu_type

OPTIND=1

while getopts z:m: flag
do
    case "${flag}" in
        z) zone=${OPTARG};;
        m) machine_type=${OPTARG};;
    esac
done

if [ "X${zone}" == "X" ]; then
    echo "Usage build-image.sh -z ZONE [-m MACHINE_TYPE]"
    exit 1
fi

substitutions="_ZONE=${zone}"

if [ "X${machine_type}" != "X" ]; then
    substitutions="${substitutions},_MACHINE_TYPE=${machine_type}"
fi

gcloud builds submit --config=cloudbuild.yaml --substitutions=${substitutions} .
