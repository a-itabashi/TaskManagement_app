class GroupsController < ApplicationController
  before_action :find_params, only: %i[show edit update destroy]
  before_action :update_or_delete, only: %i[edit update destroy]
  before_action :allow_show, only: %i[show]

  def index
    @groups = Group.all
  end

  def new
    @group =Group.new
  end

  def create
    @group = Group.new(set_params)
    @group.owner = current_user
    if @group.save
      # グループ作成と同時に、グループに参加する
      current_user.assigns.create(group_id: @group.id, leader: true)
      # @group.invite_member(@group.owner)
      flash[:success] = "グループを作成しました"
      redirect_to groups_path
    else
      flash.now[:danger] = "もう一度入力をして下さい"
      render 'new'
    end
  end

  def show
    user = @group.group_users.pluck(:id)
    @tasks = Task.where(user_id: user)
  end

  def edit; end

  def update
    if @group.update(set_params)
      flash[:success] = "グループを更新しました"
      redirect_to groups_path
    else
      flash.now[:error] = "もう一度入力をして下さい"
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:info] = "グループを削除しました"
    redirect_to groups_path

  end

  private

  def set_params
    params.require(:group).permit(:name, :content)
  end

  def find_params
    @group = Group.find(params[:id])
  end
end
