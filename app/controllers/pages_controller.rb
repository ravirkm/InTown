class PagesController < ApplicationController
  def home
    @authentications =current_user.authentications if current_user
		if user_signed_in?
		
		elsif company_signed_in?
			@event = Event.new
			@events = current_company.events.paginate(:page => params[:page])
			respond_to do |format| 
        format.html { }  
        format.js   { 
				 }  
      end
		else
			
		end
	end

  def about
	@title = 'About Us'
  end

  def help
	@title = 'Help'
  end

  def contact
	@title = 'Contact Us'
  end

end
