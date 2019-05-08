テストを修正
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
- admin:boolean

### tasksテーブル
- user_id:references
- title:string
- content:text
- status:string(未着手・着手中・完了）
- deadline:datetime
- priority:integer(高:0・中:1・低:2)

### labelテーブル
- task_id:references
- content:string

# Herokuへのデプロイ方法
1. github上のissueについて、PRをあげる。
2. github上のmasterブランチで、issueを確認後、PRをmergeする。
3. merge後、自動デプロイにて、herokuにpushされる。


# 環境
- ruby 2.6.2
- Rails 5.2.3
- psql (PostgreSQL) 11.2

