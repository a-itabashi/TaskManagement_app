class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: true
  validates :password, presence: true, length: {minimum: 5}
  before_validation { email.downcase! }
  has_secure_password
  has_many :tasks
end
