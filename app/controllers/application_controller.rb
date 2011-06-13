class ApplicationController < ActionController::Base
  protect_from_forgery
  
	unless Rails.application.config.consider_all_requests_local
	rescue_from Exception, :with => :render_error
	rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
	rescue_from ActionController::UnknownController, :with => :render_not_found
	rescue_from ActionController::UnknownAction, :with => :render_not_found
	end

	private
	def render_not_found(exception)
		render_404
	end

	def render_error(exception)
		#render :template =>"/error/500", :status => 500
	end



  def render_404
    respond_to do |format|
      format.html { render "errors/404", :status => '404 Not Found', :layout => false }
      format.xml  { render :nothing => true, :status => '404 Not Found' }
    end
    true
  end
  
  
  
end
