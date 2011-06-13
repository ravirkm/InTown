class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Welcome back, #{authentication.user.name}!"
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "New authentication service added!"
      redirect_to edit_user_registration_path
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save #which it wont, unless the user registers through a service that gives us their address
        flash[:notice] = "Signed in sucessfully!"
        redirect_to edit_user_registration_path
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_path
      end
    end
  end
  
  def failure
    omniauth = request.env["omniauth.auth"]
    flash.now[:error] = "Authentication failed!"
       
  end  
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to edit_user_registration_path, :notice => "Authentication service removed!"
  end
end
