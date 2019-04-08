FactoryBot.define do
  factory :user_1, class: User do
    name {"testマン"}
    email {"test@gmail.com"}
    password {"password"}
    password_confirmation {"password"}
  end

  factory :user_2, class: User do
    name {"productマン"}
    email {"product@gmail.com"}
    password {"password"}
    password_confirmation {"password"}
  end

  factory :admin, class: User do
    name {"adminマン"}
    email {"admin@gmail.com"}
    password {"password"}
    password_confirmation {"password"}
    admin {true}
  end
end
