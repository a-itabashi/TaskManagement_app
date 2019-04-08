class TasksController < ApplicationController
  before_action :set_params, only: %i[show edit update destroy]
  before_action :user_logged_in?
  before_action :not_show, only: %i[show]

  def index
    @statues = ["未着手","着手中","完了"]
    @priorities = {高: 0, 中: 1, 低: 2}
    
    @q = Task.ransack(params[:q])
    @tasks = @q.result.page(params[:page]).per(10)
    @tasks = @tasks.where(user_id: current_user.id)

    if params[:sort_expired]
      @tasks = Task.page(params[:page]).per(10).order(deadline: :asc)
      @tasks = @tasks.where(user_id: current_user.id)
    end

    if params[:sort_priority_expired]
      @tasks = Task.page(params[:page]).per(10).order(priority: :asc)
      @tasks = @tasks.where(user_id: current_user.id)
    end
  end

  def new
    @task = Task.new
    @task.labels.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      i = 0
      while i <  @task.label_ids.length  do
        @task.favorites.create(label_id: @task.label_ids[i])
        i += 1
      end
      flash[:success] = "タスクを登録しました"
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @task = current_user.tasks.build(task_params)
    if @task.update(task_params)
      i = 0
      while i <  @task.label_ids.length  do
        @task.favorites.create(label_id: @task.label_ids[i])
        i += 1
      end
      flash[:success] = "タスクを編集しました"
      redirect_to tasks_path
    else
      render :edit
    end



    # if @task.update(task_params)
    #   flash[:success] = "タスクを更新しました"
    #   redirect_to tasks_path
    # else
    #   render 'edit'
    # end
  end

  def destroy
    @task.destroy
    flash[:info] = "タスクを削除しました"
    redirect_to tasks_path
  end


  private
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority, label_ids:[])
  end

  def set_params
    @task = Task.find(params[:id])
  end

  def user_logged_in?
    if not_logged_in?
      flash[:info] = "ログインして下さい"
      redirect_to new_session_path
    end
  end

  def admin_allow
    unless current_user.try(:admin?)
      redirect_to tasks_path
    end
  end

  def not_show
     unless current_user.try(:admin) || @task.user_id == current_user.id
       flash[:info] = "アクセスできません"
       redirect_to tasks_path
     end
  end
end
