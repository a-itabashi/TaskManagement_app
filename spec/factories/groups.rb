FactoryBot.define do
  factory :group do
    name {"テスト用のグループ"}
    content {"テスト用のグループに関する説明"}
    owner {User.first || create(:user_1)}
  end

  factory :group_2, class: Group do
    name {"2つめのテストグループ"}
    content {"2つ目のテスト用のグループに関する説明"}
    owner {User.first || create(:user_2)}
  end
end
