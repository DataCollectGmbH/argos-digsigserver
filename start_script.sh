#!/bin/bash

# Log in to AWS
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION

# Set environment variables
export DIGSIGSERVER_KEYFILE_URI="s3://tegrasign"

# Add other commands you want to run after startup here

# Keep the container running with a bash session
exec digsigserver --debug
