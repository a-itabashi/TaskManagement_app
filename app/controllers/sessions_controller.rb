class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "ログインしました"
      redirect_to tasks_path
    else
      flash.now[:danger] = "もう一度入力をして下さい"
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:info] = "ログアウトしました"
    redirect_to root_path
  end
end
