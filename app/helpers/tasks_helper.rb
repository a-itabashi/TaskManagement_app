module TasksHelper

  def sort_by_labels
    if params[:q] != nil 
      if params[:q][:content_eq] != ""
       favorite = Favorite.where(label_id: params[:q][:content_eq])
       # 特定のラベルに紐づくtask_idの配列
       favorite_id = favorite.pluck(:task_id)
       @tasks_all = Task.where(id: favorite_id).page(params[:page]).per(10)
       @tasks = TaskDecorator.decorate_collection(@tasks_all.where(user_id: current_user.id))
      end 
    end
  end

  # controller
  def graph_data
    i = 1
    label_numbers = []
    while i < (@labels.length+1)
     label_number =  Favorite.where(label_id: i).count
     label_numbers << label_number
     i += 1
    end
    label_contents = @labels.pluck(:content) 
    @graph = [label_contents, label_numbers].transpose.to_h
  end

  def sort_by_params
    if params[:sort_params] == "deadline_expired"
      @tasks = TaskDecorator.decorate_collection(Task.page(params[:page]).per(10).order(deadline: :asc))
    elsif params[:sort_params] == "priority_expired"
      @tasks = TaskDecorator.decorate_collection(Task.page(params[:page]).per(10).order(priority: :asc).where(user_id: current_user.id))
    end
  end

  def read_params
    if params[:r]
      unless current_user.reads.find_by(task_id: params[:r])
        current_user.reads.create(task_id: params[:r])
      end
    end
  end

  def create_labels
    if @labels
      i = 0
      while i < @labels.length  do
        @favorite.create(label_id: @labels[i])
        i += 1
      end
    end
  end
end
