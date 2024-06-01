class GroupsController < ApplicationController

  def index
    @groups = Group.all
    @book = Book.new
    @user = current_user
  end

  def show
    @group = Group.find(params[:id])
    @book = Book.new
    @user = current_user
    
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

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
    
    if @group.owner_id != current_user.id
      redirect_to group_path(@group.id)
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  def new_mail
    @group = Group.find(params[:group_id])
    
    if @group.owner_id != current_user.id
      redirect_to group_path(@group.id)
    end
  end

  def send_mail
    @group = Group.find(params[:group_id])
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    ContactMailer.send_mail(@mail_title, @mail_content, @group).deliver
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
