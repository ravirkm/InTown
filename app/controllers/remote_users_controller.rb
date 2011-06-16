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
          message = "Remote user created."
        else
          @remote_user.follow!(@company)
          message = "Remote user following a new company!"
        end
      else # This email is registered to a full user
        @user.follow!(@company) 
        message = "Full user following a new company!"
      end
    else
      message = "Remote user following a new company!"
    end
    respond_to do |format|
      format.html {    #If remote user signs up on our site DOESNT HAPPEN IN PRODUCTION!
        flash[:alert] = message
        redirect_to root_path 
        } 
      format.js {    #What to send back if a remote user signs up on someone else's site
        render message
      }  
    end
  end
  
  def destroy
    RemoteUser.find(params[:id]).destroy
    flash[:alert] = "Remote user destroyed."
    redirect_to users_path
  end
  
  
end
