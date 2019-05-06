class UsersController < ApplicationController
  before_action :not_allow_new, only: %i[new]
  before_action :not_allow_show, only: %i[show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "アサインしました"
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to  user_path(@user)
    else
      flash[:danger] = "ユーザー情報の更新に失敗しました"
      redirect_to  user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin, :image)
  end

  def not_allow_new
    if logged_in?
      flash[:info] = "ログイン済みです"
      redirect_to tasks_path
    end
  end

  def not_allow_show
    @user = User.find(params[:id])
    unless current_user.try(:admin) || current_user.id == @user.id
      flash[:info] = "アクセスできません"
      redirect_to tasks_path
    end
  end
end
