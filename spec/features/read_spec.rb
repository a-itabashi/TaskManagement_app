require 'rails_helper'

RSpec.feature "Reads", type: :feature do
  def user_1_login_to_out
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
  end

  def user_2_login_to_out
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
    fill_in "終了期限", with: "2019/05/10"
    select "完了", from: "task_status"
    select "低", from: "task_priority"
    click_on "作成する"
  end

  background do
    FactoryBot.create(:user_1)
    FactoryBot.create(:user_2)
    FactoryBot.create(:second_task)
    visit root_path
    user_1_login_to_out
    user_2_login_to_out
  end

  scenario "タスク詳細画面を閲覧したら、タスク一覧画面の表示を「未読」から「既読」に変更する" do   
    all('tbody tr')[0].click_link '詳細'
    click_on "タスク管理アプリ"
    expect(page).to have_content "既読"
  end

  scenario "ユーザー自身(current_user)がタスク詳細画面を見なければ既読にならない" do 
    all('tbody tr')[0].click_link '詳細'
    click_on "ログアウト"
    click_on "ログイン"
    fill_in "メールアドレス", with: "test@gmail.com"
    fill_in "パスワード", with: "password"
    click_on "ログインする"
    expect(page).not_to have_content "既読"
  end
end
