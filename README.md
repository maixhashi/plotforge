# PlotForge（プロットフォージ）

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/maixhashi/plotforge)](https://github.com/maixhashi/plotforge/releases)
[![Rails](https://img.shields.io/badge/Rails-v6.1.6-%23a72332)](https://rubygems.org/gems/rails/versions/6.1.6)
[![Coverage Status](https://coveralls.io/repos/github/maixhashi/plotforge/badge.svg?branch=develop)](https://coveralls.io/github/maixhashi/plotfforge?branch=develop)
[![Maintainability](https://api.codeclimate.com/v1/badges/d31e5fff03ec3ea494fa/maintainability)](https://codeclimate.com/github/maixhashi/plotforge/maintainability)

### **https://plotforge.net**

## サービス概要


## 使用画面と機能紹介

| 画面1                                                         | 画面2                                                                                             |
| :------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
| <img src="https://i.gyazo.com/xxx.png"> | <img src="https://i.gyazo.com/xxx.png">                                   |
| 画面1説明              | 画面2説明 |

<br>

| 画面3                                                                                                                | 画面4                                                                                                        |
| :------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://i.gyazo.com/xxx.png">                                                       | <img src="https://i.gyazo.com/xxx.png">                                                        |
|画面3説明-1<br>画面3説明-2 | 画面4説明-1<br>画面4説明-2 |

<br>

## 使用技術

### バックエンド

- Ruby 3.1.6
- Rails 7.1.4
- RSpec 3.13
- TMDB API（外部 API）

#### 機能における主要な Gem

- devise（ログイン）
- httparty（TMDB API への接続）
- kaminari（ページネーション）
- natto (登場人物とキーワードの抽出)

#### ER 図

[![Image from Gyazo](https://i.gyazo.com/xxx.png)](https://gyazo.com/xxx)

### インフラストラクチャー

- Docker
- Nginx x.x.x
- puma x.x.x
- AWS
  - VPC
  - EC2
    - Amazon Linux 2
  - RDS
    - MySQL x.x.x
  - ALB
  - Route53
  - ACM

#### インフラ構成図

[![Image from Gyazo](https://i.gyazo.com/xxx.png)](https://gyazo.com/xxx)

## 環境構築手順
