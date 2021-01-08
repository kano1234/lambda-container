#!/bin/bash

ASSUME_ROLE_ARN=$(aws configure get profile.sandbox.role_arn)
TEMP_ROLE=$(aws sts assume-role --role-arn ${ASSUME_ROLE_ARN} --role-session-name lambda-local-test --duration-seconds 43200)
echo "-------------------------------------------------------------------------------"
echo "| The date on which the current credentials expire: $(echo ${TEMP_ROLE} | jq -r '.Credentials.Expiration') |"
echo "-------------------------------------------------------------------------------"

AWS_ACCESS_KEY_ID=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SessionToken')
AWS_DEFAULT_REGION=$(aws configure get profile.sandbox.region)

echo "=========== docker build start ==========="
docker build -t lambda-container . 
echo "=========== docker build end   ==========="

echo "=========== docker run start   ==========="
echo "----------------------------------------------------------------------------------------------------"
echo "| How to call: curl -XPOST http://localhost:9000/2015-03-31/functions/function/invocations -d '{}' |"
echo "----------------------------------------------------------------------------------------------------"

docker run \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} \
    -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
    -p 9000:8080 lambda-container
