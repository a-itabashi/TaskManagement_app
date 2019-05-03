class GroupsController < ApplicationController
  before_action :find_params, only: %i[edit update destroy]

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
      flash[:success] = "グループを作成しました"
      redirect_to groups_path
    else
      flash.now[:danger] = "もう一度入力をして下さい"
      render 'new'
    end
  end

  def edit; end

  def update
    if @group.update(set_params)
      flash[:success] = "グループを更新しました"
      redirect_to @group
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