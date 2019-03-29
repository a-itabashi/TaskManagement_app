# TaskManagement_appの概要

# Model
## Userモデル
## Taskモデル
## Labelモデル

# テーブル/カラム/データ型
## usersテーブル
- name:string
- email:string
- password_digest:string

## tasksテーブル
- user_id:references
- title:string
- content:text
- status:integer
- deadline:timestamp
- priority:integer

## labelテーブル
- task_id:references
- type:string