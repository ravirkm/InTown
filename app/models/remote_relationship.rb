class RemoteRelationship < ActiveRecord::Base

  attr_accessible :company_id
  belongs_to :remote_user
  belongs_to :company
  validates :remote_user_id, :presence => true
  validates :company_id, :presence => true







end
