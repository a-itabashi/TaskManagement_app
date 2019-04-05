require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    # ユーザー作成
    @user = create(:user)

    # サインイン
    sign_in @user
  end

  after do
    # サインアウト
    sign_out @user
  end
end
