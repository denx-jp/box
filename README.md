DENX BOX
===========

## 開発環境セットアップ方法

```zsh
$ gem install rails bundler  # RailsとBundlerがない場合は最初に入れておく
$ bundle install             # 依存ライブラリの取得
$ rake db:setup              # DB初期化
$ rails s                    # サーバー起動
```

サーバー起動後、http://localhost:3000 にアクセスするとDENX BOXが表示される。

## 本番環境セットアップ方法

```zsh
$ export RAILS_ENV=production
$ rake db:setup               # 開発環境とは異なるDBなので再度セットアップ
$ rake secret                 # これで出てきたランダム文字列を環境変数 SECRET_KEY_BASE に入れる
$ export SECRET_KEY_BASE=...
$ rake assets:precompile      # SCSS, Coffeeなどの事前コンパイル
```

## メール認証のテスト方法

```
$ gem install mailcatcher
$ mailcatcher
```

mailcatcherを起動すると http://localhost:1080 で受信ボックスを見ることができるので
そこで認証メールを受け取る
