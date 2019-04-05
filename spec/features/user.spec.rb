require 'rails_helper'

RSpec.feature "タスク管理機能", type: :feature do
  scenario "新規登録が正常に出来るかどうか" do
    visit new_user_path
    fill_in "名前", with: "テストマン"
    fill_in "メールアドレス", with: "test@gmail.com"
    fill_in "ご希望のパスワード", with: "testtest"
    fill_in "もう一度ご希望のパスワードを入力して下さい", with:"testtest"
    click_on "登録する"
    expect(page).to have_content "タスク一覧"
  end


end