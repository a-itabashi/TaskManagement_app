class AssignsController < ApplicationController
  before_action :not_allow_destroy, only: %i[destroy]

  def create
    assign = current_user.assigns.create(group_id: params[:group_id])
    flash[:success] = "グループに参加しました"
    redirect_to groups_path
  end


  def destroy
    assign = current_user.assigns.find_by(id: params[:id]).destroy
    flash[:info] = "グループを脱退しました"
    redirect_to groups_path
  end

end
