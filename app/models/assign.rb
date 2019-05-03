class Assign < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates_uniqueness_of :user_id, scope: :group_id
end

def not_allow_destroy
  @assign = Assign.find(params[:id])
  if @assign.leader == true
    flash[:info] = "脱退できません"
    redirect_to groups_path
  end 
end
