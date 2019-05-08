class TasksController < ApplicationController
  before_action :user_logged_in?
  before_action :not_edit_and_update, only: %i[edit update]

  def index
    @statues = ["未着手","着手中","完了"]
    @priorities = {高: 0, 中: 1, 低: 2} 
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result.page(params[:page]).per(10)
    @labels = Label.all
    @announce_deadline = Task.announce_deadline
    
    begin
      raise 'Something went wrong!'
    rescue => exception
      Bugsnag.notify(exception)
    end


    sort_by_labels
    sort_by_params
    graph_data
  end
  
  def new
    @task = Task.new
    @task.favorites.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    @labels = params[:task][:label_ids]
    @favorite = @task.favorites
    if @task.save
      create_labels
      flash[:success] = "タスクを登録しました"
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
    read_params
  end

  def edit
    @task = Task.find(params[:id])
    @favorite = @task.favorites_labels
  end


  def update
    @task = Task.find(params[:id])
    @labels = params[:task][:label_ids]
    @favorite = @task.favorites
    if @task.update(task_params)
      flash[:success] = "タスクを編集しました"
      redirect_to tasks_path
    else
      render :new
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:info] = "タスクを削除しました"
    redirect_to tasks_path
  end

  private
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority, :image, labels_ids:[])
  end

  def user_logged_in?
    if not_logged_in?
      flash[:info] = "ログインして下さい"
      redirect_to new_session_path
    end
  end

  def not_edit_and_update
    @task = Task.find(params[:id])
     unless current_user.try(:admin) || @task.user_id == current_user.id
       flash[:info] = "アクセスできません"
       redirect_to tasks_path
     end
  end
end
