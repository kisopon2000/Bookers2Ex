class UsersController < ApplicationController

  def index
    @user = current_user
    @users = User.all
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books.all
    
    # 投稿数の前日比・前週比
    @book_today =  @books.created_today
    @book_yesterday = @books.created_yesterday
    @book_this_week = @books.created_this_week
    @book_last_week = @books.created_last_week
    if @book_yesterday.count != 0
      @the_day_before = @book_today.count / @book_yesterday.count
    end
    if @book_last_week.count != 0
      @the_week_before = @book_this_week.count / @book_last_week.count
    end
    
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
  end

  def edit
    @user = User.find(params[:id])
    
    if @user.id != current_user.id
      redirect_to user_path(current_user.id)
    end
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

  def search
    @user = User.find(params[:user_id])
    @book = Book.new
    @books = @user.books
    
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
