# ローカル環境準備
## 事前準備
- AWS CLIの設定

## Git clone

```
cd ~
mkdir Git
cd Git
git clone https://github.com/kano1234/lambda-container.git
```

# ローカルでのlambda起動
起動shellを実行する

```
cd ~/Git/lambda-container
./docker-build.sh
```

curl or postman からlambdaを呼び出して動作確認を行う。

```
curl --location --request POST 'http://localhost:9000/2015-03-31/functions/function/invocations' \
--header 'Content-Type: text/plain' \
--data-raw '{"zip": "1310045"}'
```

**実行には1時間の有効期限があるため、有効期限が切れた場合は再度実行すること。  
設定方法は右記を参照：
[ロールの最大セッション期間設定の表示](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_use.html#id_roles_use_view-role-max-session)**

# ローカルテスト
ローカルテスト用のshellを実行する

```
cd test
./local-test.sh
```
