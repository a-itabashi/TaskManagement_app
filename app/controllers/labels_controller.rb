class LabelsController < ApplicationController
  before_action :admin_allow
  
  def index
    @labels = Label.all
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.build(set_params)
    if @label.save
      flash[:success] = "ラベルを作成しました"
      redirect_to labels_path
    else
      flash.now[:danger] = "もう一度入力をして下さい"
      render 'new'
    end
  end

  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    flash[:info] = "ラベルを削除しました"
    redirect_to labels_path
  end

  private
  def set_params
    params.require(:label).permit(:content, :task_id, :user_id)

  end

  def admin_allow
    unless current_user.try(:admin?)
      flash[:danger] = "権限がありません"
      redirect_to tasks_path
    end
  end

end
