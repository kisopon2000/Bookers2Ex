class SearchesController < ApplicationController
  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == "User"
      @users = User.search(@search, @word)
    else
      @books = Book.search(@search, @word)
    end
  end
  
  def search_tag
    @model = Book
    @word = params[:word]
    @books = Book.where("category LIKE?","%#{@word}%")
    render "search_tag"
  end
end
