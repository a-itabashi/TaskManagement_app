require 'rails_helper'
RSpec.describe User, type: :model do
  it '名前、メールアドレス、パスワードが指定の入力値であれば、invalidしないかどうか' do
    user = User.new(
      name:"testマン",
      email:"test@gmail.com",
      password:"testtest"
      )
    expect(user).to be_valid
  end 

  it "名前に入力がなければエラーメッセージが出るかどうか" do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "メールアドレスに入力がなければエラーメッセージが出るかどうか" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "メールアドレスに重複があればinvalidするかどうか" do
    User.create(
      name:"testマン",
      email:"test@gmail.com",
      password:"testtest"
      )
    user = User.new(
      name:"testウーマン",
      email:"test@gmail.com",
      password:"ttttttt"
      )
    user.valid?
    expect(user).to be_invalid
  end
end
