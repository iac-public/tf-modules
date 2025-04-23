## 1.はじめに

### 1-1.ドキュメントの位置づけ

モジュールの利用方法と実装内容を理解するための資料です。

### 1-2.モジュールの目的

フロントエンドのデプロイするための基盤を構築するためのモジュールです。

### 1-3.リソース構成

自動構築されるAWSリソースは下記です。

```
ACM
CloudFront
S3
```
構成図は下記を参考にする。


## 2.使用方法

### 2-1.使用前提
    -　AWS環境があること
    -　terraform実行環境があること
    -　DNS検証済みのACMが既に作成してあること
    -　Route53でのドメイン登録とレコード作成は別途行う必要がある

### 2-2.概要

```
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

module frontend {
    source "git::https://github.com/infra-public/tf-modules.git//aws/infra_frontend?ref=<version>"
    system_name = <value>
    env = <value>
    domain_name = <value>
    
    providers = {
        aws.tokyo    = aws.tokyo
        aws.virginia = aws.virginia
    }
}
```

### 2-3.Variablesの説明
    - system_name 任意のシステム名を入力
    - env　任意の環境名を入力
    - record_name　登録済みレコード名を入力

### 2-4.使用例

```
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

module frontend {
    source "git::https://github.com/infra-public/tf-modules.git//aws/infra_frontend?ref=v1.0.0"
    system_name = "myblog"
    env = "dev"
    record_name = "example.com"

    providers = {
        aws.tokyo    = aws.tokyo
        aws.virginia = aws.virginia
    }
}
```

### 2-4.備考

・cloudfrontの仕様上applyに時間がかかる