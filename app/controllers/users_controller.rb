class UsersController < ApplicationController
 before_filter :admin_user, :only => [ :destroy, :index]
 
  
 
 def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
    @remote_users = RemoteUser.paginate(:page => params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  
  
  private
  
    def admin_user
      if user_signed_in?
        redirect_to(root_path) unless current_user.admin
      else
        redirect_to(root_path)
      end
    end
end
