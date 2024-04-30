class BooksController < ApplicationController
  before_action :is_matching_author?, only: [:edit, :update, :destroy]
  
  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.all.sort {|a,b|
      b.favorites.where(created_at: from...to).size <=>
      a.favorites.where(created_at: from...to).size
    }
    @new_book = Book.new
    @user = current_user
  end
  
  def create
    @new_book = Book.new(book_params)
    @new_book.user_id = current_user.id
    if @new_book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@new_book.id)
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end 

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @new_book = Book.new
    @book_comment = BookComment.new
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end 
  end

  def edit
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end 
  
  def destroy
    Book.find(params[:id]).destroy
    redirect_to books_path
  end 
  
  private
  
  def book_params
    params.require(:book).permit(:title, :body, :image, :star)
  end 
  
  def is_matching_author?
    book = Book.find(params[:id])
    unless current_user.id == book.user_id
      redirect_to books_path
    end 
  end 
end
