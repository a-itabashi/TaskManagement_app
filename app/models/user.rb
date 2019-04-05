class User < ApplicationRecord
 validates :name, presense: true, length: {maximum: 50}
 validates :email, presense: true, length: {maximum: 255},
 validates :password, presense: true, length: {minimum: 5} 
  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
  uniqueness: true,
 before_validation { email.downcase! }
 has_secure_password
 has_many :tasks
end
