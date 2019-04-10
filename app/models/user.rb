class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: true
  validates :password, presence: true, length: {minimum: 5}
  before_save { email.downcase! }
  has_secure_password
  has_many :tasks, dependent: :destroy
  has_many :labels

  before_destroy :delete_admin

  private

  def delete_admin
    if self.admin.count <= 1
       flash[:danger] = "管理者を居なくなってしまうため、削除できません"
       redirect_to root_path
    end
  end
end
