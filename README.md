# PlotForge（プロットフォージ）

[![Rails](https://img.shields.io/badge/Rails-v6.1.6-%23a72332)](https://rubygems.org/gems/rails/versions/6.1.6)
[![Maintainability](https://api.codeclimate.com/v1/badges/d31e5fff03ec3ea494fa/maintainability)](https://codeclimate.com/github/maixhashi/plotforge/maintainability)

### **https://plotforge.net**

## サービス概要
**ランダムに作成される映画のあらすじから「この映画いいかも」を見つけよう**
<br>
ランダムに作成されるユニークなあらすじから映画を発掘・共有することができるサービスです

## 使用画面と機能紹介

| アカウント作成画面                                                         | ログイン画面                                                                                             |
| :------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
| ![image](https://github.com/user-attachments/assets/b3b0623f-0a2c-43f6-be0f-fe0eab8635c8) |![image](https://github.com/user-attachments/assets/1d05126b-5e1a-44b5-8698-3d881a4e7481)|
| アカウントを作成する画面              | ログインをする画面 |

<br>

| ホーム画面                                                         |　あらすじ作成画面                                                                                             |
| :------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
| ![image](https://github.com/user-attachments/assets/f0222456-d72a-45f7-98f4-03ddca57d7e3)|![image](https://github.com/user-attachments/assets/e1f4741e-65af-46c7-9e36-2c03f13637f8)|
|・ヘッダーのハンバーガーボタンにより各画面へ<br>・「あらすじ」ボタンであらすじ作成画面へ遷移|・あらすじが自動作成される。<br>・「保存」ボタンであらすじ詳細画面へ遷移し、登場人物とキーワードも共に作成<br>・あらすじ音声読み上げ機能<br>・完成したあらすじの文章をhoverすると、あらすじの元になっている映画を表示 |

<br>

| あらすじ詳細画面                                                                                                                | マイページ                                                                                                        |
| :------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| ![image](https://github.com/user-attachments/assets/70cd0c80-edd2-4906-9858-e08992772459)| ![image](https://github.com/user-attachments/assets/fda73824-65f5-4611-a482-5fef6589b15a)|
|・あらすじの内容を表示<br>・あらすじをブックマーク<br>・あらすじの登場人物、キーワードを表示|　ユーザーの作成したあらすじ・映画や、ブックマークしたあらすじ・映画を表示 |

<br>

| フォロー一覧画面                                                                                                                | フォロワー一覧画面                                                                                                        |
| :------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| ![image](https://github.com/user-attachments/assets/61fa8677-8493-45c9-955d-87733e2157b6)| ![image](https://github.com/user-attachments/assets/cc8b3ab9-898b-443c-9d04-ac31cd6ab832) |
|ユーザーがフォローしたアカウントを表示 | ユーザーをフォローしているアカウントを表示 |

<br>

| ユーザー情報編集画面                                                                                                                | アバター編集画面                                                                                                        |
| :------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| ![image](https://github.com/user-attachments/assets/a197b5cb-2873-4a86-8e85-b3c99dfcdcd7)|![image](https://github.com/user-attachments/assets/f0f9cb0b-bc35-4afc-b923-f820eab6db6d)|
|ユーザー情報の編集ができる | ユーザーのアバターを編集ができる |


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
![image](https://github.com/user-attachments/assets/9a2c1be4-8dc9-42d5-b70c-52ba370647a1)


### インフラストラクチャー

- Docker
- Nginx 1.15.8
- puma 6.4.2
- AWS
  - VPC
  - EC2
    - Amazon Linux 2
  - RDS
    - MySQL 8.0.35
  - ALB
  - Route53
  - ACM

#### インフラ構成図
![image](https://github.com/user-attachments/assets/e57016a5-ee32-4561-8b7f-9c21f9ffa0b6)
