class UsersController < ApplicationController
  before_action :not_allow, only: %i[new]

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

  def not_allow
    if logged_in?
      flash[:info] = "ログイン済みです"
      redirect_to tasks_path
    end
  end
end
