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
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:notice] = "タスクを登録しました"
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
    if @task.update(task_params)
      flash[:notice] = "タスクを更新しました"
      redirect_to tasks_path
    else
      render 'edit'
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = "タスクを削除しました"
    redirect_to tasks_path
  end


  private
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority)
  end

  def set_params
    @task = Task.find(params[:id])
  end

  def user_logged_in?
    if not_logged_in?
      flash[:info] = "ログインまたは会員登録をして下さい"
      redirect_to root_path
    end
  end

  def not_show
    unless @task.user_id === current_user.id
      redirect_to tasks_path
    end
  end
end
