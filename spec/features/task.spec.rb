require 'rails_helper'

RSpec.feature "タスク管理機能", type: :feature do
  background do
  FactoryBot.create(:task ,title:"testesttest", deadline:"2019-04-10") 
  FactoryBot.create(:second_task, title:"samplesample", deadline:"2019-04-01")
  end

  scenario "タスク一覧のテスト" do
    visit root_path
    expect(page).to have_content "testesttest"
    expect(page).to have_content "samplesample"
    expect(page).to have_content "2019年04月01日"
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
    click_on "終了期限でソートする"
    task_1 = Task.first
    task_2 = Task.second
    expect(task_1.id).to be < task_2.id
  end
end