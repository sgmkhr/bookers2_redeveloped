class GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  
  def new
    @group = Group.new
  end

  def index
    @new_book = Book.new
    @user = User.find(current_user.id)
    @groups = Group.all
  end

  def show
    @new_book = Book.new
    @user = User.find(current_user.id)
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end
  
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to group_path(@group.id)
    else
      render :new
    end
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end
  
  def destroy
    Group.find(params[:id]).destroy
    redirect_to groups_path, notice: 'グループが削除されました。'
  end
  
  private
  
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end 
  
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end 
  end
  
end
