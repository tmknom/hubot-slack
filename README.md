# Slack × Hubot 連携スクリプト


## 事前準備

事前に、SlackのIntegrations設定から、API Tokenを発行しておく。


## ローカルで動かす

### 前提条件

* node.jsがインストール済みであること
* Hubotがインストール済みであること

### セットアップ

```bash
$ git clone git@github.com:tmknom/hubot-slack.git
$ cd hubot-slack
$ npm install
```

### 環境変数のセット

```bash
$ export HUBOT_SLACK_TOKEN=xxxxxxxx
```

### Hubotの起動

```bash
$ bin/hubot -a slack
```


## Herokuへデプロイ

### 前提条件

* Herokuのアカウントが作成済みであるとと
* Heroku Toolbeltがインストール済みであること

### Herokuへアプリケーションをデプロイ

```bash
$ heroku login
$ heroku create
$ git push heroku master
```

### HerokuのSlack連携設定

```bash
$ heroku config:add HUBOT_SLACK_TOKEN=xxxxxxxx
```

### Herokuのアイドリング防止設定

```bash
$ heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s | grep web_url | cut -d= -f2)
```

### Herokuのタイムゾーン変更

```bash
$ heroku config:add TZ=Asia/Tokyo
```

### 動作確認

ローカルの時と同様。
