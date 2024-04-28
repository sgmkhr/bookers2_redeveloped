class UsersController < ApplicationController
  before_action :is_matching_user?, only: [:edit, :update]
  before_action :ensure_guest_user?, only: [:edit]
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end 

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @new_book = Book.new
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @user = current_user
    @new_book = Book.new
  end
  
  def search 
    @user = User.find(params[:user_id])
    @books = @user.books
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      created_at = params[:created_at]
      @search_book = @books.where(["created_at LIKE ?", "#{created_at}%"]).count
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end 
  
  def is_matching_user?
    user = User.find(params[:id])
    unless current_user.id == user.id
      redirect_to user_path(current_user.id)
    end 
  end
  
  def ensure_guest_user?
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end 
  end 
end
