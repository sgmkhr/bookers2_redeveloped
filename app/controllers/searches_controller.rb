class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @method = params[:method]
    @content = params[:content]
    if @model == 'user'
      @records = User.search_for(@content, @method)
    else
      @records = Book.search_for(@content, @method)
    end 
  end
  
end
