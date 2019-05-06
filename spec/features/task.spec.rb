require 'rails_helper'

RSpec.feature "タスク管理機能", type: :feature do
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

   def create_labels
      FactoryBot.create(:admin)
      visit root_path
      click_on "ログイン"
      fill_in "メールアドレス", with: "admin@gmail.com"
      fill_in "パスワード", with: "password"
      click_on "ログインする"
      click_on "ラベル新規作成"
      fill_in "ラベル名", with: "ラベルA"
      click_on "作成する"
      click_on "ラベルを作成する"
      fill_in "ラベル名", with: "ラベルB"
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
    expect(page).to have_content "タイトルA" && "テストの内容A"
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

  scenario "タスクに複数のラベルをつけられるかどうか" do
  
  end

  context "ラベルを生成できる権限について" do
    scenario "管理者は生成できるかどうか" do
      create_labels
    end 
    scenario "管理者は生成できないかどうか" do
      visit root_path
      click_on "ログイン"
      fill_in "メールアドレス", with: "test@gmail.com"
      fill_in "パスワード", with: "password"
      click_on "ログインする"
      visit new_label_path
      expect(page).to have_content "権限がありません"
    end
  end

  scenario "詳細画面でタスクに紐づくラベル一覧が見れるかどうか" do
      create_labels
      visit root_path
      click_on "ログイン"
      fill_in "メールアドレス", with: "test@gmail.com"
      fill_in "パスワード", with: "password"
      click_on "ログインする"
      find(".new_task").click
      fill_in "タスク名", with: "タスク名A"
      fill_in "詳細", with: "詳細A"
      fill_in "終了期限", with: "2020/04/10"
      select "完了", from: "task_status"
      select "低", from: "task_priority"
      check "task_label_ids_1"
      check "task_label_ids_2"
      click_on "作成する"
      expect(page).to have_content "ラベルA" && "ラベルB"
  end

  scenario "ラベル検索で、自分のタスクのみソートできるかどうか" do
      create_labels
      visit root_path
      user_1_login_to_out
      click_on "ログイン"
      fill_in "メールアドレス", with: "test@gmail.com"
      fill_in "パスワード", with: "password"
      click_on "ログインする"
      find(".new_task").click
      fill_in "タスク名", with: "タスク名A"
      fill_in "詳細", with: "詳細A"
      fill_in "終了期限", with: "2020/04/10"
      select "完了", from: "task_status"
      select "低", from: "task_priority"
      check "task_label_ids_3"
      check "task_label_ids_4"
      click_on "作成する"
      select "ラベルA", from: "q_content_eq"
      click_on "検索"
      expect(page).not_to have_content "タイトルA" && "タイトルB"
 end

 scenario "ログイン後のタスク一覧ページに、終了７日前・期限の過ぎたタスク(状態が完了のものは除く)を表示したい" do
      within("#deadline_rspec") do
        expect(page).not_to have_content "完了"
        expect(page).to have_content "2019年04月01日"
        expect(page).to have_content "2019年05月10日"
      end
 end

 scenario "カレンダーに、タスクの終了期限を紐付けて表示出来ているか" do

     find('#task_calender86').click
     expect(page).to have_content "テストの内容D"

 end

end