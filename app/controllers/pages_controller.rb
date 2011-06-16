class PagesController < ApplicationController
  def home
    @user = User.new
    @authentications = current_user.authentications if current_user
    if user_signed_in?
    
    elsif company_signed_in?
      @event = Event.new
      @events = current_company.events.paginate(:page => params[:page])
      respond_to do |format| 
	format.html { }  
	format.js   { }  
      end
    else
    
    end
  end

  def about
	@title = 'About Us'
	session[:unreg_user] = nil
  end

  def help
	@title = 'Help'
  end

  def contact
	@title = 'Contact Us'
  end

end
