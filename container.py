import os
import logging
import requests
import json
import boto3

# boto3にてAWSリソースにアクセスするテスト
rds = boto3.client('rds')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

class LambdaResponse:
    # コンストラクタ
    def __init__(self, db, zip):
        self.db = db
        self.zip = zip
    # json形式で返却
    def json(self):
        db = {}
        instances = []
        for instance in self.db['DBInstances']:
            res = {}
            res['Identifier'] = instance['DBInstanceIdentifier']
            res['Status'] = instance['DBInstanceStatus']
            instances.append(res)
        
        db['Instances'] = instances
        return {
            'db': db,
            'zip': self.zip
        }

def lambda_handler(event, context):
    logger.info('event: {}'.format(event))
    # お試しDescribe
    describe = rds.describe_db_instances(DBInstanceIdentifier='xxxxxxxxx')
    logger.info('describe db instances: {}'.format(describe))
    # Defaultライブラリーに含まれない機能を試す
    response = requests.get('https://zipcloud.ibsnet.co.jp/api/search?zipcode={}'.format(event['zip']))
    logger.info('Status: {}, Body: {}'.format(response.status_code, json.dumps(response.json(), ensure_ascii=False)))
    return LambdaResponse(describe, response.json()).json()
