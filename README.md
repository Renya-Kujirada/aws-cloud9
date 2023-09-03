# CloudFormationを利用したDeep Learning開発環境@EC2の自動構築・Cloud9初期セットアップ方法 <!-- omit in toc -->

本リポジトリでは，AWS CloudFormationを利用し，EC2上にDeep Learning開発環境を自動構築するためのtemplate yamlを公開している．
本ドキュメントでは，このtemplate yamlとその利用方法について解説する．加えて，Cloud9を利用し，自動構築したEC2上でクラウドネイティブに開発を行う方法についても解説する．

## 目次 <!-- omit in toc -->
- [背景](#背景)
- [CloudFormation templateについて](#cloudformation-templateについて)
  - [概要](#概要)
  - [構築するリソース](#構築するリソース)
  - [利用する AMI](#利用する-ami)
  - [template内のUserData内の補足](#template内のuserdata内の補足)
- [CloudFormation 実行手順](#cloudformation-実行手順)
- [](#)
- [2023/08/30追記](#20230830追記)
- [実行手順](#実行手順)
- [Cloud9 EC2環境の方が優れている点](#cloud9-ec2環境の方が優れている点)
  - [CloudFormation templateについて](#cloudformation-templateについて-1)
  - [DL環境@EC2自動構築手順](#dl環境ec2自動構築手順)
  - [Cloud9を利用する方法](#cloud9を利用する方法)
    

## 背景

Cloud9には，EC2環境とSSH環境という2種類のリソースの種別が存在する．EC2環境とは，EC2インスタンスを新規作成し，作成したEC2インスタンスにSSM Session Managerによって接続する方式のことである．SSH環境とは，既存のEC2インスタンスSSHに接続する方式のことである．

EC2環境の場合，EC2のライフサイクルを全てCloud9が自動で管理するため，ユーザ側での管理負担が少ないメリットがある．このため，通常Cloud9を利用する場合，EC2環境で環境構築することが多い．[[1]](https://docs.aws.amazon.com/ja_jp/cloud9/latest/user-guide/ssh-settings.html)[[2]](https://docs.aws.amazon.com/ja_jp/cloud9/latest/user-guide/ec2-env-versus-ssh-env.html)

しかし，現状（2023/09/03），Cloud9でEC2環境を構築する場合，EC2インスタンスの初期スペックや利用可能なAMIに大きな制約が存在するため，以下に示すような課題が発生してしまう．
これにより，Cloud9を利用したDeep Learning環境を容易に構築することができない．
- Deep Learning用のAMIを選択できないため，以下の作業を全て手動で実施する必要がある．
  - NVIDIA ドライバのインストール
  - NVIDIA Container Toolkit のインストール
  - （必要があれば適宜）CUDAおよびcuDNN, Pytorch, Tensorflow のインストール
- GPUインスタンスを選択できず，選択可能なインスタンスの種別は全てCPUであり，種類も少ない
- インスタンスのボリュームサイズを指定できない（初期ボリュームサイズは10GB）

加えて，現時点（2023/09/03）では，CloudFormationでCloud9を構築する場合，既存のEC2を指定したSSH環境を構築することはできない．一方，CloudFormationでEC2インスタンス自体を作成する場合，上記の課題は全て生じない．

そこで．EC2をCloudFormationで自動構築し，SSH環境のCloud9を作成することで，クラウドネイティブなDeep Learning環境を容易に構築できるようにした．

## CloudFormation templateについて

### 概要

[今回作成したCloudFormation template](https://github.com/Renya-Kujirada/aws-cloud9/blob/master/cloudformation/cftemplate_ec2_for_deep_learning.yaml)では，Deep Learning AMIを利用したEC2インスタンスを構築する．その後，作成したEC2にSSH接続する形（SSH環境）でCloud9を利用することを想定している．
なお，SSH接続するために，以下に示す工夫を施している．
- EC2 Key pairを作成
- 静的なIPアドレス（Elastic IP）をEC2にアタッチ
- ポート番号22, 80をインバウンドルールとして許可するセキュリティグループを作成

### 構築するリソース

- EC2
- EC2 Key pair
- Elastic IP
- Security Group

### 利用する AMI

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

### template内のUserData内の補足

- [SSH 環境ホスト要件](https://docs.aws.amazon.com/ja_jp/cloud9/latest/user-guide/ssh-settings.html)として，Python2とNode.jsがインストールされている必要があるため，これらをインストールしている．
- AMIのgitのバージョンが古いため，gitをアップグレードしている
- Cloud9で快適にコーディングを行えるよう，autopep8をインストールしている

## CloudFormation 実行手順
[cloudformation/cftemplate_ec2_for_deep_learning.yaml](https://github.com/Renya-Kujirada/aws-cloud9/blob/master/cloudformation/cftemplate_ec2_for_deep_learning.yaml)を利用する．
詳細な手順は以下を参照されたい．


## 
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

## 2023/08/30追記
- ec2をcloudformationで作成できるようにした．これにより，以下のステップでcloud9環境を構築可能
  - cloudformation templateでec2, Elastic IP構築
    - パブリックサブネットに自動で割り当て
    - Elastic IPアドレスに自動で割り当て
    - python2, nodejsのinstallは自動実行
    - セキュリティグループはdefault vpc上に自動で作成
- cloud9の公開鍵を `.ssh/authirized_key` に追記
  - `echo "PUBKEYの内容" >> .ssh/authirized_key`
- cloud9環境構築
  - aws configureの設定
  - stop my environmentの設定（自動でインスタンス停止してくれる設定）


## 実行手順

- `/home/renya/Develop/aws/aws-cloud9/cloudformation/cftemplate_ec2_for_deep_learning.yaml`をテンプレートとして利用し，cloudformationを実行．
  - 作成するリソース等多いため，admin権限を一時的に利用しても良いかもしれない．
- cloud9を作成
  - 名前を任意で決める
  - 既存のコンピューティングリソースを選択し，SSHパブリックキーをコピー
  - cloudformationで作成したEC2にログインし，パブリックキーを ~/.ssh/authorized_keys ファイルに追加
- cloud9 IDEを開くと，cloud9 installが始まる
  - デフォルト通り，全てinstallしてOK
- 本リポジトリをcloneし，`project_settings`に移動
- `bash setup_preference.sh`を実行



## Cloud9 EC2環境の方が優れている点
- SSM接続可能なので，いちいちEC2を起動せずとも直接アクセス可能
- AWS Managed Temporary Credentials（AMTC）による，一時的な認証情報の利用が可能な点（実質ほぼ無制限に他のリソースとの連携が可能）

### CloudFormation templateについて

### DL環境@EC2自動構築手順

### Cloud9を利用する方法
