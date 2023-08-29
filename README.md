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

- Deep Learning AMIを利用することで，以下が全て自動実行されることを確認した．Dockerコンテナ環境でGPUがすぐに利用できる状態であることも確認できた．
  - NVIDIA ドライバのインストール
  - Docker のインストール
  - NVIDIA Container Toolkit のインストール

- しかし，通常のCloud9からEC2を作成する場合と異なり，以下の設定が追加必要であることも確認した．
  - EC2インスタンス作成時の設定
    - ネットワーク設定（パブリックサブネットに割り当てる必要あり）
    - セキュリティグループのインバウンド・アウトバウンド設定
      - インバウンド：ssh, 0.0.0.0/0
      - アウトバウンド：http, https, 0.0.0.0/0
  - EC2インスタンス上での作業
    - sudo apt-get update && sudo apt-get -y upgrade
    - sudo apt-get -y install nodejs
    - sudo apt -y install python2
    - vi .ssh/authirized_key で公開鍵追記
    - Elastic IPアドレスの割り振り

  - cloud9上での作業
    - aws configureの設定
    - stop my environmentの設定（自動でインスタンス停止してくれる設定）

- その他の差分としては，以下の点が若干利用しづらい
  - Cloud9を利用する前に手動でEC2を起動しなければならない

# 2023/08/30追記
- ec2をcloudformationで作成できるようにした．これにより，以下のステップでcloud9環境を構築可能
  - cloudformation templateでec2, Elastic IP構築
    - パブリックサブネットに自動で割り当て
    - Elastic IPアドレスに自動で割り当て
    - python2, nodejsのinstallは自動実行
    - TODO: セキュリティグループは既存のものを利用
- cloud9の公開鍵を ``.ssh/authirized_key` に追記
- cloud9環境構築
  - aws configureの設定
  - stop my environmentの設定（自動でインスタンス停止してくれる設定）