require 'rails_helper'

RSpec.feature "タスク管理機能", type: :feature do
  scenario "タスク一覧のテスト" do
    Task.create!(title:"test_task_01", content:"testesttest")
    Task.create!(title:"test_task_02", content:"samplesample")
    visit tasks_path
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
  # タスクの作成
    visit new_task_path
    fill_in "タスク名", with: "test@gmail.com"
    fill_in "詳細", with: "テストの内容だよ"
    click_on "作成する"
  # タスクの詳細
    click_on "詳細"
    expect(page).to have_content "test@gmail.com" && "テストの内容だよ"
  end
end