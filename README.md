# TaskManagement_appの概要  
## Model
### *Userモデル*
#### *Taskモデル*
### *Labelモデル*
* * *
## テーブル/カラム/データ型
### usersテーブル
- name:string
- email:string
- password_digest:string

### tasksテーブル
- user_id:references
- title:string
- content:text
- status:integer
- deadline:datetime
- priority:integer

### labelテーブル
- task_id:references
- type:string

# Herokuへのデプロイ方法
1. github上のissueについて、PRをあげる。
2. github上のmasterブランチで、issueを確認後、PRをmergeする。
3. merge後、自動デプロイにて、herokuにpushされる。


# 環境
- ruby 2.6.2
- Rails 5.2.3
- psql (PostgreSQL) 11.2

