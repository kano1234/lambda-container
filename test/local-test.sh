#!/bin/bash

if ! [ -d ./local-env ]; then
    python3 -m venv local-env
fi

cd local-env
source bin/activate

echo "------ pip upgrade  ------"
python -m pip install --upgrade pip
echo "------ version info ------"
echo "$(python -V) from $(which python)"
pip -V

echo "------ pip install  ------"
pip install -r ../../requirements.txt
echo "------ pip list     ------"
pip list

# ローカル実行時のboto3認証情報を設定
ASSUME_ROLE_ARN=$(aws configure get profile.sandbox.role_arn)
TEMP_ROLE=$(aws sts assume-role --role-arn ${ASSUME_ROLE_ARN} --role-session-name lambda-local-test --duration-seconds 43200)
export AWS_ACCESS_KEY_ID=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SessionToken')
export AWS_DEFAULT_REGION=$(aws configure get profile.sandbox.region)

# テスト対象pyファイルをexport
SCRIPT_DIR=$(cd ../../; pwd)
export PYTHONPATH="${PYTHONPATH}:${SCRIPT_DIR}"

echo "------ test run     ------"
python ../container-test.py

deactivate
