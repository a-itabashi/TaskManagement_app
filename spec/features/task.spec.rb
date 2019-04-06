require 'rails_helper'

RSpec.feature "タスク管理機能", type: :feature do
  background do
    FactoryBot.create(:user_1)
    FactoryBot.create(:user_2)
    visit root_path
    # user_1
    click_on "ログイン"
    fill_in "メールアドレス", with: "test@gmail.com"
    fill_in "パスワード", with: "password"
    click_on "ログインする"
    find('.new_task').click
    fill_in "タスク名", with: "タイトルA"
    fill_in "詳細", with: "テストの内容A"
    fill_in "終了期限", with: "2020/04/01"
    select "着手中", from: "task_status"
    select "高", from: "task_priority"
    click_on "作成する"
    find('.new_task').click
    fill_in "タスク名", with: "タイトルB"
    fill_in "詳細", with: "テストの内容B"
    fill_in "終了期限", with: "2020/04/10"
    select "完了", from: "task_status"
    select "低", from: "task_priority"
    click_on "作成する"
    click_on "ログアウト"

    # user_2
    click_on "ログイン"
    fill_in "メールアドレス", with: "product@gmail.com"
    fill_in "パスワード", with: "password"
    click_on "ログインする"
    find('.new_task').click
    fill_in "タスク名", with: "タイトルC"
    fill_in "詳細", with: "テストの内容C"
    fill_in "終了期限", with: "2019/04/01"
    select "着手中", from: "task_status"
    select "高", from: "task_priority"
    click_on "作成する"
    find('.new_task').click
    fill_in "タスク名", with: "タイトルD"
    fill_in "詳細", with: "テストの内容D"
    fill_in "終了期限", with: "2020/04/10"
    select "完了", from: "task_status"
    select "低", from: "task_priority"
    click_on "作成する"
  end

  scenario "タスク一覧のテスト" do
    expect(page).to have_content "タイトルC" && "タイトルD" 
  end

  scenario "タスク詳細のテスト" do
    click_on "ログアウト"
    Task.delete_all
    click_on "ログイン"
    fill_in "メールアドレス", with: "test@gmail.com"
    fill_in "パスワード", with: "password"
    click_on "ログインする"
    find('.new_task').click
    fill_in "タスク名", with: "タイトルA"
    fill_in "詳細", with: "テストの内容A"
    fill_in "終了期限", with: "2020/04/01"
    select "着手中", from: "task_status"
    select "高", from: "task_priority"
    click_on "作成する"
    click_on "詳細"
    expect(page).to have_content "タイトルA" && "テストの内容A" && "2020年04月01日"
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
    tasks = Task.all.order(created_at: "desc")
    task_1 = tasks.first
    task_2 = tasks.second
    expect(task_1.created_at).to be > task_2.created_at
  end
 
  scenario "終了期限ボタンを押したらタスクが終了期限を元にソートされているか" do
    click_on "終了期限でソートする(期限が近い順に)"
    task_titles = page.all('.task_title').map(&:text)
    expect(task_titles[0]).to have_content "タイトルC"
    expect(task_titles[1]).to have_content "タイトルD"
  end

  scenario "タスク名・状態検索をし、期待する検索結果が出力されるか" do
    fill_in "タスク名検索", with: "test"
    select "着手中", from: "q_status_cont"
    click_on "検索"
    expect(page).to have_content "testesttest" && "着手中"
  end

  scenario "存在しないタスク名で検索をし、何も表示されないか" do
    fill_in "タスク名検索", with: "令和"
    select "", from: "q_status_cont"
    click_on "検索"
    expect(page).not_to have_content "testesttest"
  end

  scenario "タスク名のみで検索をし、期待する検索結果が出力されるか" do
    fill_in "タスク名検索", with: "タイトルC"
    select "", from: "q_status_cont"
    click_on "検索"
    expect(page).to have_content "テストの内容C" 
  end

  scenario "状態検索のみで検索をし、期待する検索結果が出力されるか" do
    fill_in "タスク名検索", with: ""
    select "着手中", from: "q_status_cont"
    click_on "検索"
    expect(page).to have_content "着手中" 
  end

  scenario "タスク名・状態検索共に、何も入力されずに、期待する検索結果が出力されるか" do
    fill_in "タスク名検索", with: ""
    select "", from: "q_status_cont"
    click_on "検索"
    expect(page).to have_content "testesttest" && "samplesample" && "着手中" && "未着手" && "2019年04月10日" && "2019年04月01日"
  end

  scenario "優先順位(高中低)を登録できるか" do
    Task.delete_all
    visit new_task_path
    fill_in "タスク名", with: "test@gmail.com"
    fill_in "詳細", with: "テストの内容だよ"
    fill_in "終了期限", with: "2020/04/01"
    select "着手中", from: "状態検索"
    select "高", from: "優先順位"
    click_on "作成する"
    expect(page).to have_content "test@gmail.com" && "テストの内容だよ" && "2020年04月01日" && "着手中" && "高"
  end

  scenario "タスク一覧を、優先順位で高い順にソートできるか" do
    click_on "優先順位でソートする(高い順に)"
    task_titles = page.all('.task_title').map(&:text)
    expect(task_titles[0]).to have_content "タイトルC"
    expect(task_titles[1]).to have_content "タイトルD"
  end

  scenario "タスク一覧に自分が作成したタスクのみ表示されているか" do
    expect(page).not_to have_content "タイトルA"
    expect(page).not_to have_content "タイトルB"
  end
end