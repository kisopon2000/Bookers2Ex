class RoomsController < ApplicationController
  def create
    room = Room.create(user_id: current_user.id)
    Entry.create(room_id: room.id, user_id: current_user.id)
    Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => room.id))
    
    redirect_to room_path(room.id)
  end
  
  def show
    @room = Room.find(params[:id])
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
      @entries.each do |entry|
        if entry.user.id != current_user.id
           @follow_user = entry.user
           break
        end
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
