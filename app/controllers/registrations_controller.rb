class RegistrationsController < Devise::RegistrationsController
  
  
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
    if session[:unreg_user]
      @remote_user = RemoteUser.find_by_email(session[:unreg_user][:email])
      @user.address = @remote_user.address
        for c in @remote_user.companies
          @user.relationships.create(:company_id => c.id)
        end
      @user.save
      @remote_user.destroy #remove for debugging
      session[:unreg_user] = nil
      end
  end
  
  def edit
    @authentications =current_user.authentications if current_user
    super
  end
  
  
  def update
    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end
  
  
  
  private 
  
    def build_resource(*args)
      super
      if session[:omniauth]
        @user.apply_omniauth(session[:omniauth])
        #@user.valid?
      end
      if session[:unreg_user]
        puts "Building #{@user.email}!"
        @user.build_from_remote(session[:unreg_user])
      end
    end

end
