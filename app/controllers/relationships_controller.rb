class RelationshipsController < ApplicationController
  #before_filter :authenticate

  def create
    @company = Company.find(params[:relationship][:company_id])
    current_user.follow!(@company)
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js
    end
  end

  def destroy
    @company = Relationship.find(params[:id]).company
    current_user.unfollow!(@company)
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js
    end
  end
  
end
