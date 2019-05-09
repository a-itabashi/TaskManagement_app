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


# ローカル環境上で、Circle CIによるRSpec/Rubocop及び、bugsnagの挙動確認手順

## Circle CIによるRSpec/Rubocopの挙動確認方法
- githubへcommitしたタイミングで、Circle CIを走らせてます。

rubocopについて起動をさせると、コード内の日本語に反応して、
修正を指摘されます。  
※rspecのみ走らせたい場合は、下記記述をコメントアウトすることにより、対応できます。この場合、テストは通る
ので、Circle CI上、「success」になるはずです。


  
/.circleci/config.yml
```
- run:
    name: rubocop
    command: bundle exec rubocop
```

## bugsnagの挙動確認手順
方法は3つあります。  
1, コマンドに以下を入力してエラーを発生させる。
```
bundle exec rake bugsnag:test_exception
```
2, プロフィールページにアクセスをする(該当するファイルにエラー発生用の下記コードを埋め込んでます)

/controller/tasks_controller.rbのshowアクション
```
# bugsnag
    begin
      raise 'Something went wrong!'
    rescue => exception
      Bugsnag.notify(exception)
    end
```


3, 適当にコードをいじって、エラーを意図的に発生させる。








