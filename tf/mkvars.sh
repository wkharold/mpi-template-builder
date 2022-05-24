#!/usr/bin/env bash

OPTIND=1

unset name_prefix
unset machine_type

while getopts g:n:m: flag
do
    case "${flag}" in
        n) name_prefix=${OPTARG};;
        m) machine_type=${OPTARG};;
    esac
done

if [ "X${name_prefix}" == "X" ] || [ "X${machine_type}" == "X" ]; then
    echo "usage mkvars.sh -n NAME_PREFIX [-m MACHINE_TYPE]"
    return 1
fi

varfile=$(date +%j%H%M%S.tfvars)
touch $varfile

pid=$(gcloud config get-value core/project)
echo project_id=\""${pid}\"" >> $varfile
echo name_prefix=\""${name_prefix}\"" >> $varfile
echo image=\""$(gcloud compute images list --filter="name ~ julia" --format="value(name)" | sort -r | head -n1)\"" >> $varfile 
echo image_project=\""${pid}\"" >> $varfile

if [ "X${machine_type}" != "X" ]; then
    echo machine_type=\""${machine_type}\"" >> $varfile
fi

echo $varfile
