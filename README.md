DENX BOX
===========

## 必要なMySQL環境

- ユーザー `box_denx_jp`

## 開発環境セットアップ方法

```zsh
$ gem install rails bundler  # RailsとBundlerがない場合は最初に入れておく
$ bundle install             # 依存ライブラリの取得
$ rake db:setup              # DB初期化
$ rails s                    # サーバー起動, ポート番号を変更したい場合は -p 5000 のようにオプション指定
```

サーバー起動後、http://localhost:3000 にアクセスするとDENX BOXが表示される。

## 本番環境セットアップ方法

以下の条件のMySQLデータベースを準備する
（DB設定ファイルを参照してもわかる：https://github.com/denx-jp/box/blob/master/config/database.yml）

- ホスト `192.168.0.120`
- データベース名: `box_denx_jp_production` 
- ユーザー `box_denx_jp` (上のデータベースに対して全権限を持っている必要あり）
- パスワード 環境変数 `BOX_DENX_JP_DATABASE_PASSWORD` の値

```zsh
$ export RAILS_ENV=production
$ rake db:setup               # 開発環境とは異なるDBなので再度セットアップ
$ rake secret                 # これで出てきたランダム文字列を環境変数 SECRET_KEY_BASE に入れる
$ export SECRET_KEY_BASE=...
$ export BOX_DENX_JP_DATABASE_PASSWORD=...  # 本番データベースのパスワードを環境変数に入れる
$ rake assets:precompile      # SCSS, Coffeeなどの事前コンパイル
$ rails s                     # サーバー起動
```

## メール認証のテスト方法

```
$ gem install mailcatcher
$ mailcatcher
```

mailcatcherを起動すると http://localhost:1080 で受信ボックスを見ることができるので
そこで認証メールを受け取る

## Slack通知
ファイル作成，削除，更新時にSlackに通知する機能を有効にするには，環境変数 `SLACK_WEBHOOK_URL` に incoming webhook のURLを指定してサーバーを起動する
