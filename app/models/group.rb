class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :assigns, dependent: :destroy

  # あるグループに紐づくuser一覧を取得
  has_many :group_users, through: :assigns, source: :user

def update_or_delete
  unless current_user.id == @group.owner_id
    flash[:info] = "権限がありません"
    redirect_to groups_path
  end
end

def allow_show
  unless current_user.id == @group.assigns.where(user_id: 1).pluck(:user_id)[0]
    flash[:info] = "権限がありません"
    redirect_to groups_path
  end
end

end

