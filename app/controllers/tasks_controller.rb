class TasksController < ApplicationController
  before_action :set_params, only: %i[show edit update destroy]


  def index
    @statues = ["未着手","着手中","完了"]
    @priorities = {高: 0, 中: 1, 低: 2}
    
    @q = Task.ransack(params[:q])
    @tasks = @q.result

    if params[:sort_expired]
      @tasks = Task.all.order(deadline: :asc)
    end

    if params[:sort_priority_expired]
      @tasks = Task.all.order(priority: :asc)
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "タスクを登録しました"
      redirect_to root_path
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
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = "タスクを削除しました"
    redirect_to root_path
  end


  private
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority)
  end

  def set_params
    @task = Task.find(params[:id])
  end
end
