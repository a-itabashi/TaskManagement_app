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
    @tasks = current_user.tasks
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def not_allow_new
    if logged_in?
      flash[:info] = "ログイン済みです"
      redirect_to tasks_path
    end
  end

  def not_allow_show 
    @user = User.find(params[:id]) 
    unless current_user.id == @user.id
    flash[:info] = "アクセスできません"
    redirect_to tasks_path
    end
  end
end
