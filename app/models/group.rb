class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :assigns, dependent: :destroy

  # あるグループに紐づくuser一覧を取得
  has_many :group_users, through: :assigns, source: :user
end

