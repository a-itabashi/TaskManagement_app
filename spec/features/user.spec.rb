require 'rails_helper'

RSpec.feature "タスク管理機能", type: :feature do
  scenario "新規登録が正常に出来るかどうか" do
    visit new_user_path
    fill_in "名前", with: "テストマン"
    fill_in "メールアドレス", with: "test@gmail.com"
    fill_in "ご希望のパスワード", with: "testtest"
    fill_in "もう一度ご希望のパスワードを入力して下さい", with:"testtest"
    click_on "登録する"
    expect(page).to have_content "タスク一覧" && "アサインしました"
  end

  scenario "ログインが正常に出来るかどうか" do
    FactoryBot.create(:user_1)
    visit root_path
    click_on "ログイン"
    fill_in "メールアドレス", with: "test@gmail.com"
    fill_in "パスワード", with: "password"
    click_on "ログインする"
    expect(page).to have_content "タスク一覧" && "ログインしました"
  end

  scenario "ログアウトが正常に出来るかどうか" do
    FactoryBot.create(:user_1)
    visit root_path
    click_on "ログイン"
    fill_in "メールアドレス", with: "test@gmail.com"
    fill_in "パスワード", with: "password"
    click_on "ログインする"
    click_on "ログアウト"
    expect(page).to have_content "ログアウトしました"
  end

  scenario "ログインしていないのにタスクページにアクセスしたらログインページに飛ぶかどうか" do
     visit tasks_path
     expect(page).to have_content "ログイン" && "ログインして下さい"
  end

  scenario "ログインしている時は、ユーザー登録画面（new画面）に行かないかどうか" do
     FactoryBot.create(:user_1)
     visit root_path
     click_on "ログイン"
     fill_in "メールアドレス", with: "test@gmail.com"
     fill_in "パスワード", with: "password"
     click_on "ログインする"
     visit new_user_path
     expect(page).to have_content "タスク一覧" && "ログイン済みです"
  end

  scenario "自分以外のマイページに行かないかどうか" do
     FactoryBot.create(:user_1)
     visit root_path
     click_on "ログイン"
     fill_in "メールアドレス", with: "test@gmail.com"
     fill_in "パスワード", with: "password"
     click_on "ログインする"
     visit user_path(2)
     expect(page).to have_content "タスク一覧" && "アクセスできません"
  end
end