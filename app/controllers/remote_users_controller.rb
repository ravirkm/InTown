class RemoteUsersController < ApplicationController
  def post
    @email = (params[:remote_user][:email])
    puts @email
    @company = Company.find_by_company_name(params[:remote_user][:remote_company])
    unless @company.nil?
      @user = User.find_by_email(@email)
      if @user.nil? # This email is not registered to a full user on the site
        @remote_user = RemoteUser.find_by_email(@email)
        if @remote_user.nil? # This email hasn't been used on a remote form before
          @remote_user = RemoteUser.create(params[:remote_user])
        end
        @remote_user.follow!(@company)
      else # This email is registered to a full user
        @user.follow!(@company) 
      end
    else
      puts 'no such company, we need to register this company!'
    end
  end
  
end
