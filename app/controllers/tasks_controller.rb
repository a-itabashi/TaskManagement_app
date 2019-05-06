class TasksController < ApplicationController
  before_action :user_logged_in?
  # before_action :not_show, only: %i[show]
  before_action :admin_allow, only: %i[edit update]

  def index
    @statues = ["未着手","着手中","完了"]
    @priorities = {高: 0, 中: 1, 低: 2}
 
    # パラメーター値を元に、tssksを成形
    @q = current_user.tasks.ransack(params[:q])

    # resultメソッドで、テーブルからレコードを持ってくる
    @tasks = @q.result.page(params[:page]).per(10)
    # @tasks = @tasks.where(user_id: current_user.id)
    
    @labels = Label.all

    if params[:q] != nil 
      if params[:q][:content_eq] != ""
       favorite = Favorite.where(label_id: params[:q][:content_eq])
       # 特定のラベルに紐づくtask_idの配列
       favorite_id = favorite.pluck(:task_id)
       @tasks_all = Task.where(id: favorite_id).page(params[:page]).per(10)
       @tasks = @tasks_all.where(user_id: current_user.id)
      end 
    end

    # 棒グラム用のデータ抽出
    i = 1
    label_numbers = []
    while i < (@labels.length+1)
     label_number =  Favorite.where(label_id: i).count
     label_numbers << label_number
     i += 1
    end
    label_contents = @labels.pluck(:content) 
    @graph = [label_contents, label_numbers].transpose.to_h


    # @labels_arr_pre = Label.all
    # @labels_empty = []
    # if @labels_arr
    #   i = 0
    #   while i < @labels_arr.length
    #     @labels_arr << @labels_arr[i].content
    #     i += 1
    #   end
    # end

    # if params[:content_eq] == "板橋のラベル"
    #   @content = params[:content_eq]
    #   @label_id = Label.find_by(content: @content)
    #   @favorite_tasks = Favorite.where(label_id: @label_id)
      
    #   @task_ids = []
    #     i = 0
    #     while i < @favorite_tasks.length
    #       @task_ids << @favorite_tasks[i].task_id
    #       i += 1
    #     end

    #   @pre_tasks = Task.where(user_id: current_user.id).where(id: @task_ids)
    #   @tasks = @pre_tasks.page(params[:page]).per(10)
    # end

    if params[:sort_expired] == "true"
      @tasks = Task.page(params[:page]).per(10).order(deadline: :asc)
      @tasks = @tasks.where(user_id: current_user.id)
    end

    if params[:sort_priority_expired]
      @tasks = Task.page(params[:page]).per(10).order(priority: :asc)
      @tasks = @tasks.where(user_id: current_user.id)
    end

  # 終了間近・期限過ぎてる・完了以外のタスク一覧
  @announce_deadline = Task.where("deadline <= ?", (Time.zone.today+7.day)).where("status != ?", "完了")

  end
  
  def new
    @task = Task.new
    @task.favorites.build
    # @favorite = @task.favorites
  end

  def create

    # @task = current_user.tasks.build(task_params)

      @task = Task.new(task_params)
      @task.user_id = current_user.id
      @labels = params[:task][:label_ids]
      @favorite = @task.favorites
      if @task.save

      if @labels
        i = 0
        while i < @labels.length  do
          @favorite.create(label_id: @labels[i])
          i += 1
        end
      end

      flash[:success] = "タスクを登録しました"
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])

    # 既読・未読の判定
    if params[:r]
      unless current_user.reads.find_by(task_id: params[:r])
        current_user.reads.create(task_id: params[:r])
      end
    end


  end

  def edit
    @task = Task.find(params[:id])
    @favorite = @task.favorites_labels
  end


  def update
    @task = Task.find(params[:id])
    # @task = Task.new(task_params)
    #   @task.user_id = current_user.id
      @labels = params[:task][:label_ids]
      @favorite = @task.favorites
      if @task.update(task_params)
      # # @task = current_user.build(task_params)
      # if @labels
      #   i = 0
      #   while i < @labels.length  do
      #     @favorite.update(label_id: @labels[i])
      #     i += 1
      #   end
      # end
      flash[:success] = "タスクを編集しました"
      redirect_to tasks_path
    else
      render :new
    end
  end

  # def update
  #   @task = current_user.tasks.build(task_params)
  #   if @task.update(task_params)
  #     i = 0
  #     while i <  @task.label_ids.length  do
  #       @task.favorites.update(label_id: @task.label_ids[i])
  #       i += 1
  #     end
  #     flash[:success] = "タスクを編集しました"
  #     redirect_to tasks_path
  #   else
  #     render :edit
  #   end



  #   # if @task.update(task_params)
  #   #   flash[:success] = "タスクを更新しました"
  #   #   redirect_to tasks_path
  #   # else
  #   #   render 'edit'
  #   # end
  # end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:info] = "タスクを削除しました"
    redirect_to tasks_path
  end


  private
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority, labels_ids:[])
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
    @task = Task.find(params[:id])
     unless current_user.try(:admin) || @task.user_id == current_user.id
       flash[:info] = "アクセスできません"
       redirect_to tasks_path
     end
  end
end
