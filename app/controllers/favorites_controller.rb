class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    favorite = Favorite.find_by(book_id: @book.id, user_id: current_user.id)
    if favorite.nil?
      favorite = current_user.favorites.new
      favorite.book_id = @book.id
      favorite.save
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    if !favorite.nil?
      favorite.destroy
    end
  end
end
