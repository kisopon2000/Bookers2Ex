class GroupUsersController < ApplicationController

  def create
    group_user = current_user.group_users.new(group_id: params[:group_id])
    group_user.save
    
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    group_user = current_user.group_users.find_by(group_id: params[:group_id])
    group_user.destroy
    
    redirect_back(fallback_location: root_path)
  end
end
