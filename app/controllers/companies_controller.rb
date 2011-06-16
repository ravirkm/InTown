class CompaniesController < ApplicationController
 before_filter :admin_user, :only => :destroy
 
 
 
 def index
    @companies = Company.search(params[:search]).paginate(:page => params[:page])
  end

  
  def destroy
   #redirect_to cancel_project_registration_path
    Company.find(params[:id]).destroy
    flash[:notice] = "Company destroyed."
    redirect_to companies_path
  end
  
  
  
  
  
  
  
  
  private
  
    def admin_user
      redirect_to(root_path) unless current_user.admin
    end


end
