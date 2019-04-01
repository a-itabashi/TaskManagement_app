require 'rails_helper'

RSpec.feature "タスク管理機能", type: :feature do
  background do
  FactoryBot.create(:task ,title:"testesttest") 
  FactoryBot.create(:second_task, title:"samplesample")
  end

  scenario "タスク一覧のテスト" do
    visit root_path
    expect(page).to have_content "testesttest"
    expect(page).to have_content "samplesample"
  end

  scenario "タスク作成のテスト" do
    visit new_task_path
    fill_in "タスク名", with: "test@gmail.com"
    fill_in "詳細", with: "テストの内容だよ"
    click_on "作成する"
    expect(page).to have_content "test@gmail.com" && "テストの内容だよ"
  end

  scenario "タスク詳細のテスト" do
  # タスクの作成。一度、backgroundで生成したレコードを削除
    Task.delete_all
    visit new_task_path
    fill_in "タスク名", with: "test@gmail.com"
    fill_in "詳細", with: "テストの内容だよ"
    click_on "作成する"
  # タスクの詳細
    click_on "詳細"
    expect(page).to have_content "test@gmail.com" && "テストの内容だよ"
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
    visit root_path
    tasks = Task.all.order(created_at: "desc")
    expect(tasks.first).to eq Task.all.last
  end
end