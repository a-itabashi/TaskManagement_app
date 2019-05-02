require 'rails_helper'

RSpec.feature "管理ユーザー機能", type: :feature do
  def admin_login
    visit root_path
    click_on "ログイン"
    fill_in "メールアドレス", with: "admin@gmail.com"
    fill_in "パスワード", with: "password"
    click_on "ログインする"
  end

  def user_login
    visit root_path
    click_on "ログイン"
    fill_in "メールアドレス", with: "test@gmail.com"
    fill_in "パスワード", with: "password"
    click_on "ログインする"
  end

  background do
    FactoryBot.create(:user_1)
    FactoryBot.create(:user_2)
    admin_user = FactoryBot.create(:admin)
  end

  feature "ユーザー一覧機能" do
      scenario "管理ユーザーがアクセスした時、一覧が見れるかどうか" do
        admin_login
        click_on "ユーザー一覧"
        expect(page).to have_content "test@gmail.com" && "product@gmail.com" && "admin@gmail.com"
      end

      scenario "管理ユーザー以外がアクセスした時、一覧は表示されないかどうか" do 
        user_login
        expect(page).not_to have_content "ユーザー一覧"
      end

      scenario "管理ユーザー以外がアクセスした時(直接リンクを叩いて)、一覧は表示されないかどうか" do 
        user_login
        visit admin_users_path
        expect(page).to have_content "アクセス権限がありません"
      end

      scenario "ユーザーを新規作成できるかどうか" do
        admin_login
        click_on "ユーザー新規作成"
        fill_in "名前", with: "新規ユーザー"
        fill_in "メールアドレス", with: "new@gmail.com"
        fill_in "ご希望のパスワード", with: "password"
        fill_in "もう一度ご希望のパスワードを入力して下さい", with: "password"
        click_on "登録する"
        expect(page).to have_content "ユーザー登録に成功しました"
      end

      scenario "ユーザ-詳細を見れるかどうか" do
        user = User.all
        user.delete_all
        admin_user = FactoryBot.create(:admin)
        admin_login
        click_on "ユーザー一覧"
        click_on "詳細"
        expect(page).to have_content "admin@gmail.com"
      end

      scenario "管理者のみユーザ-詳細を更新できるかどうか" do
        user = User.all
        user.delete_all
        admin_user = FactoryBot.create(:admin)
        admin_login
        click_on "ユーザー一覧"
        click_on "編集"
        fill_in "名前", with: "更新マン"
        fill_in "ご希望のパスワード", with: "password"
        fill_in "もう一度ご希望のパスワードを入力して下さい", with: "password"
        click_on "登録する"
        expect(page).to have_content "ユーザー情報を更新しました"
      end

      # テスト実施済み
      # scenario "ユーザ-を削除できるかどうか" do
      #   user = User.all
      #   user.delete_all
      #   admin_user = FactoryBot.create(:admin)
      #   admin_login
      #   click_on "ユーザー一覧"
      #   click_on "削除"
      #   expect(page).to have_content "アクセス権限がありません"
      # end

      scenario "管理者が誰も居なくなってしまう場合に、管理者を削除できないかどうか" do
        user = User.all
        user.delete_all
        admin_user = FactoryBot.create(:admin)
        admin_login
        click_on "ユーザー一覧"
        click_on "削除"
        expect(page).to have_content "管理者を居なくなってしまうため、削除できません"
      end
  end
end