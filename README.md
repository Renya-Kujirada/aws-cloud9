# cloud9初期セットアップ & docker環境構築用リポジトリ

- 今回，以下に示すDeep Learning AMIを利用してEC2インスタンスを構築し．そのEC2にssh接続する形でCloud9を作成した．

```
Deep Learning AMI GPU PyTorch 2.0.1 (Ubuntu 20.04) 20230827
ami-06c414f3ba4a59e2f (64 ビット (x86))
仮想化: hvm
ENA 有効: true
ルートデバイスタイプ: ebs
説明
Supported EC2 instances: P5, P4d, P4de, P3, P3dn, G5, G4dn, G3. Release notes: https://docs.aws.amazon.com/dlami/latest/devguide/appendix-ami-release-notes.html
アーキテクチャ
64 ビット (x86)

AMI ID
ami-06c414f3ba4a59e2f
```

- Deep Learning AMIを利用することで，以下が全て自動実行されることを確認した．
  - NVIDIA ドライバのインストール
  - Docker のインストール
  - NVIDIA Container Toolkit のインストール

- しかし，通常のCloud9からEC2を作成する場合と異なり，以下の設定が追加必要であることも確認した．
  - EC2インスタンス上での作業
    - sudo apt-get update && sudo apt-get -y upgrade
    - sudo apt-get -y install nodejs
    - sudo apt -y install python2
    - vi .ssh/authirized_key で公開鍵追記
    - Elastic IPアドレスの割り振り

  - cloud9上での作業
    - aws configureの設定
    - stop my environmentの設定（自動でインスタンス停止してくれる設定）