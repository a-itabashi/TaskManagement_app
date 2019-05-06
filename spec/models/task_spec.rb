require 'rails_helper'
RSpec.describe Task, type: :model do
  it "titleが空ならバリデーションが通らない" do
    task = Task.new(title: '', content: '失敗テスト')
    expect(task).not_to be_valid
  end

  it "contentが空ならバリデーションが通らない" do
    task = Task.new(title: '失敗テスト', content: '')
    expect(task).not_to be_valid
  end

  it "titleとcontentとdeadlineに内容が記載されていればバリデーションが通る" do
    user = FactoryBot.create(:user_1)
    task = Task.new(title: "成功テスト", content:"成功テスト", deadline:"2020/04/01")
    task.user_id = user.id
    expect(task).to be_valid
  end

  it "終了間近のタスクを持っているユーザーにバッチ処理でメール送信できるかどうか" do
    @announce_deadline = Task.where("deadline <= ?", (Time.zone.today+7.day)).where("deadline > ?", (Time.zone.today)).where("status != ?", "完了")

    i = 0
    while i <  @announce_deadline.length do
      list = @announce_deadline[i]
      mail = DeadlineMailer.deadline(list).deliver
      expect(mail.subject).to eq('終了期限間近のタスクがあります')
      i += 1
    end
  end
end
