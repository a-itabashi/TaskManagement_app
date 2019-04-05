require 'rails_helper'

RSpec.feature "タスク管理機能", type: :feature do
  background do

  
  # user_1 = User.create(name: "testマン", email:"test@gmail.com", password:"testtest")
  # user_2 = User.create(name: "productマン", email:"product@gmail.com", password:"productproduct")
  

  # user_1.create(title:"testesttest", deadline:"2019-04-10", status:"着手中", priority: 2)
  # user_2.create(title:"samplesample", deadline:"2019-04-01", status:"完了",priority:0)
  # FactoryBot.create(:task ,title:"testesttest", deadline:"2019-04-10", status:"着手中", priority: 2, user_id: 1) 
  # FactoryBot.create(:second_task, title:"samplesample", deadline:"2019-04-01", status:"完了",priority:0, user_id: 2)
  end

  scenario "タスク一覧のテスト" do
    visit root_path
    expect(page).to have_content "testesttest"
    expect(page).to have_content "samplesample"
    expect(page).to have_content "2019年04月01日"
    expect(page).to have_content "完了"
    expect(page).to have_content "低"
  end

  scenario "タスク作成のテスト" do
    visit new_task_path
    fill_in "タスク名", with: "test@gmail.com"
    fill_in "詳細", with: "テストの内容だよ"
    fill_in "終了期限", with: "2020/04/01"
    click_on "作成する"
    expect(page).to have_content "test@gmail.com" && "テストの内容だよ" && "2020年04月01日"
  end

  scenario "タスク詳細のテスト" do
  # タスクの作成。一度、backgroundで生成したレコードを削除
    Task.delete_all
    visit new_task_path
    fill_in "タスク名", with: "test@gmail.com"
    fill_in "詳細", with: "テストの内容だよ"
    fill_in "終了期限", with: "2020/04/01"
    click_on "作成する"
  # タスクの詳細
    click_on "詳細"
    expect(page).to have_content "test@gmail.com" && "テストの内容だよ" && "2020年04月01日"
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
    visit root_path
    tasks = Task.all.order(created_at: "desc")
    task_1 = tasks.first
    task_2 = tasks.second
    expect(task_1.created_at).to be > task_2.created_at
  end
 
  scenario "終了期限ボタンを押したらタスクが終了期限を元にソートされているか" do
    visit root_path
    click_on "終了期限でソートする(期限が近い順に)"
    task_titles = page.all('.task_title').map(&:text)
    expect(task_titles[0]).to have_content "samplesample"
    expect(task_titles[1]).to have_content "testesttest"
  end

  scenario "タスク名・状態検索をし、期待する検索結果が出力されるか" do
    visit root_path
    fill_in "タスク名検索", with: "test"
    select "着手中", from: "q_status_cont"
    click_on "検索"
    expect(page).to have_content "testesttest" && "着手中"
  end

  scenario "存在しないタスク名で検索をし、何も表示されないか" do
    visit root_path
    fill_in "タスク名検索", with: "令和"
    select "", from: "q_status_cont"
    click_on "検索"
    expect(page).not_to have_content "testesttest"
  end

  scenario "タスク名のみで検索をし、期待する検索結果が出力されるか" do
    visit root_path
    fill_in "タスク名検索", with: "test"
    select "", from: "q_status_cont"
    click_on "検索"
    expect(page).to have_content "testesttest" 
  end

  scenario "状態検索のみで検索をし、期待する検索結果が出力されるか" do
    visit root_path
    fill_in "タスク名検索", with: ""
    select "着手中", from: "q_status_cont"
    click_on "検索"
    expect(page).to have_content "着手中" 
  end

  scenario "タスク名・状態検索共に、何も入力されずに、期待する検索結果が出力されるか" do
    visit root_path
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
    visit root_path
    click_on "優先順位でソートする(高い順に)"
    task_titles = page.all('.task_title').map(&:text)
    expect(task_titles[0]).to have_content "samplesample"
    expect(task_titles[1]).to have_content "testesttest"
  end
end