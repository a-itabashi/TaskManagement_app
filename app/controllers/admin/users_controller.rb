class Admin::UsersController < ApplicationController
  before_action :user_admin?



  private

  def user_admin?
    unless current_user.try(:admin?)
      flash[:damger] = "アクセス権限がありません"
      redirect_to root_path
    end
  end
end