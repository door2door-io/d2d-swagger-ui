#!/bin/sh

if [ $# -ne 1 ]
  then
    echo "\\nYou must provide as arguments:\\n" \
         "    1) terraform action, such 'plan', 'apply', etc.\\n\\n" \
         "Example execution:\\n" \
         "    ./tf.sh plan"
    exit
fi

export TF_VAR_AWS_REGION="eu-central-1"
export TF_VAR_BUCKET_NAME="d2d-playground-infrastructure"
export TF_VAR_AWS_PROFILE="d2d-play"

rm -rf .terraform/*
terraform get

terragrunt $1
