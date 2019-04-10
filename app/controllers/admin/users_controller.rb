class Admin::UsersController < ApplicationController
  before_action :user_admin?
  before_action :user_params, only: %i[show edit update destroy]
  before_action :delete_admin, only: %i[destroy]

  def index
    @users = User.select(:id,:name, :email, :admin).page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(set_params)
    if @user.save
      flash[:success] = "ユーザー登録に成功しました"
      redirect_to admin_users_path
    else
      flash[:danger] = "ユーザ登録に失敗しました"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user.destroy
    flash[:info] = "ユーザー情報を削除しました"
    redirect_to tasks_path
  end

  private

  def user_admin?
    unless current_user.try(:admin?)
      flash[:danger] = "アクセス権限がありません"
      redirect_to root_path
    end
  end

  def set_params
    params.require(:user).permit(:name,:email, :password, :password_confirmation)
  end

  def user_params
    @user = User.find(params[:id])
  end


  def delete_admin
    if User.where(admin: true).count <= 1
       flash[:danger] = "管理者を居なくなってしまうため、削除できません"
       redirect_to tasks_path
    end
  end
end