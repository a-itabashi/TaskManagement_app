require 'rails_helper'

RSpec.feature "Groups", type: :feature do
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
    fill_in "終了期限", with: "2020/04/10"
    select "完了", from: "task_status"
    select "低", from: "task_priority"
    click_on "作成する"
  end

  background do
    FactoryBot.create(:user_1)
    FactoryBot.create(:user_2)
    FactoryBot.create(:group)
    visit root_path
    user_2_login_to_out
  end

  scenario "グループを作成できる" do
    click_on "グループ新規作成"
    fill_in "グループ名", with: "グループA"
    fill_in "グループの説明", with: "グループAの説明です"
    click_on "作成する"
    expect(page).to have_content "グループA" && "グループAの説明です"
  end

  scenario "グループ情報の編集や削除はそのグループの作成者のみができるようにする" do
    click_on "グループ一覧"
    expect(page).not_to have_content "詳細" && "編集" && "削除" 
  end

  scenario "グループに自由にユーザーが参加できるようにしたい" do
    click_on "グループ一覧"
    click_on "参加"
    expect(page).to have_content "グループに参加しました"
  end

  context "グループの詳細画面にはそのグループの参加者のみが行けるようにする" do
    scenario "まだ該当のグループに参加していない場合"  do
      click_on "グループ一覧"
      expect(page).not_to have_content "編集"
    end

    scenario "まだ該当のグループに参加している場合"  do
      click_on "グループ一覧"
      click_on "参加"
      click_on "グループ一覧"
      expect(page).to have_content "詳細"
    end
  end

  context "ユーザーは複数のグループに参加できるものとする。また、離脱できるものとする" do
    scenario "ユーザーは複数のグループに参加できる"  do
      FactoryBot.create(:group_2)
      click_on "グループ一覧"
      all('tbody tr')[0].click_link '参加'
      expect(page).to have_content "グループに参加しました"
      all('tbody tr')[1].click_link '参加'
      expect(page).to have_content "グループに参加しました"
    end

    scenario "ユーザーはグループを離脱できる"  do
      click_on "グループ一覧"
      all('tbody tr')[0].click_link '参加'
      expect(page).to have_content "グループに参加しました"
      click_on "脱退"
      expect(page).to have_content "グループを脱退しました"
    end
  end

  scenario "グループの作成者は、最初からそのグループに参加しているものとして扱い、離脱もできないようにする" do
    click_on "グループ新規作成"
    fill_in "グループ名", with: "グループA"
    fill_in "グループの説明", with: "グループAの説明です"
    click_on "作成する"
    expect(page).not_to have_content "離脱"
  end

  scenario "グループの詳細画面で、そのグループのユーザーたちが持っているタスクを参照できるようにしたい" do
    FactoryBot.create(:task)
    click_on "グループ一覧"
    all('tbody tr')[0].click_link '参加'
    click_on "詳細"
    expect(page).to have_content "タイトルC" && "タイトルD"
  end
end
