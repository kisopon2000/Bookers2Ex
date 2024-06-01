class BooksController < ApplicationController

  def index
    @book = Book.new
    @user = User.find(current_user.id)
    
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:star_count]
      @books = Book.star_count
    else
      # いいねの多い順にソート
      to = Time.current.at_end_of_day
      from = (to - 6.day).at_beginning_of_day
      @books = Book.includes(:favorited_users).
        sort_by {|x|
          x.favorited_users.includes(:favorites).where(created_at: from...to).size
        }.reverse
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end

  def show
    @book = Book.new
    @book_show = Book.find(params[:id])
    @book_comment = BookComment.new
    @user = @book_show.user
    
    # チャット
    @current_user_entries = Entry.where(user_id: current_user.id)
    @user_entries = Entry.where(user_id: @user.id)
    if @user.id != current_user.id
      @current_user_entries.each do |current_user_entry|
        @user_entries.each do |user_entry|
          if current_user_entry.room_id == user_entry.room_id then
            @is_room = true
            @room_id = current_user_entry.room_id
            break
          end
        end
      end
      
      if !@is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
    
    # 閲覧数
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_show.id)
      current_user.view_counts.create(book_id: @book_show.id)
    end
  end

  def edit
    @book = Book.find(params[:id])

    if @book.user_id != current_user.id
      redirect_to books_path
    end
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
    @book = Book.find(params[:id])
    @book.destroy
    
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :body, :star, :category)
  end
end
