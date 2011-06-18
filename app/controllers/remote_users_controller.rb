class RemoteUsersController < ApplicationController
  
  def new
    @remote_user = RemoteUser.new
  end
  
  def transform
    temp = RemoteUser.find_by_email(params[:email])
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
          @remote_user = RemoteUser.new(params[:remote_user])
          if @remote_user.save
            @remote_user.follow!(@company)
            message = "Remote user created."
            response = "success"
          else
            message = "Remote user NOT created."
            response = "failure"
          end
        else
          @remote_user.address = params[:remote_user][:address]
          if @remote_user.save
            @remote_user.follow!(@company)
            message = "Remote user updated."
            response = "success"
          else
            message = "Remote user NOT updated."
            response = "failure"
          end
        end
      else # This email is registered to a full user
        @user.address = params[:remote_user][:address]
        if @user.save
          @user.follow!(@company)
          message = "Full user updated."
          response = "success"
        else
          message = "Full user NOT updated."
          response = "failure"
        end
      end
    else
      message = "Company not registered!"
      response = "failure"
    end
    respond_to do |format|
      if response == "success"
        format.html {    #If remote user signs up on our site DOESNT HAPPEN IN PRODUCTION!
          flash[:notice] = message
          redirect_to root_path 
          } 
        format.js {    #What to send back if a remote user signs up on someone else's site
          #render :text => message
        }
      else
        format.html {    #If remote user signs up on our site DOESNT HAPPEN IN PRODUCTION!
          flash[:error] = message
          redirect_to new_remote_user_path
          } 
        format.js {    #What to send back if a remote user signs up on someone else's site
          #render :text => message
        }
      end
    end
  end
  
  def destroy
    RemoteUser.find(params[:id]).destroy
    flash[:notice] = "Remote user destroyed."
    redirect_to users_path
  end
  
  
end
