class RemoteUsersController < ApplicationController
  
  def new
    @remote_user = RemoteUser.new
  end
  
  def transform
    temp = RemoteUser.find_by_email(params[:remote_user][:email])
    unless temp
      unless User.find_by_email(params[:remote_user][:email])
        flash[:error] = "Sorry, this email isn't associated with any EventAlerts account."
        redirect_to root_path
      else
        flash[:error] = "Sorry, this email is already registered on EventAlerts! Please use the regular signin form above!"
        redirect_to root_path
      end
    else
      session[:unreg_user] = {:email => temp.email, :address => temp.address}
      redirect_to new_user_registration_path
    end
  end
  
  
  def create
    @email = (params[:remote_user][:email])
    @company = Company.find_by_company_name(params[:remote_user][:remote_company])
    unless @company.nil?
      @user = User.find_by_email(@email)
      if @user.nil? # This email is not registered to a full user on the site
        @remote_user = RemoteUser.find_by_email(@email)
        if @remote_user.nil? # This email hasn't been used on a remote form before
          @remote_user = RemoteUser.create(params[:remote_user])
          @remote_user.follow!(@company)
          flash[:notice] = "Remote user created."
          redirect_to root_path
        else
          @remote_user.follow!(@company)
          flash[:notice] = "Remote user is following a new company."
          redirect_to root_path
        end
      else # This email is registered to a full user
        @user.follow!(@company) 
        flash[:notice] = "Full user is following a new company."
        redirect_to root_path
      end
    else
      flash[:error] = 'no such company, we need to register this company!'
      redirect_to root_path
    end
  end
  
  def destroy
    RemoteUser.find(params[:id]).destroy
    flash[:success] = "Remote user destroyed."
    redirect_to users_path
  end
  
  
end
