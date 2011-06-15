require 'geocoder'
class RemoteUser < ActiveRecord::Base
  attr_accessor :remote_company
  attr_accessible :email, :address
  has_many :remote_relationships, :dependent => :destroy
  has_many :companies, :through => :remote_relationships 
  validates :email, :presence => true
  validates :address, :presence => true
  geocoded_by :address
  after_validation :geocode  
  
  
  
  def following?(company)
    if remote_relationships.find_by_company_id(company.id).nil?
      return false
    else
      return true
    end
  end
  
  def follow!(company)
    unless self.following?(company)
      remote_relationships.create!(:company_id => company.id, :remote_user_id => self.id)
    end
  end
		
  def num_following
    return self.companies.all.size
  end

	
  def unfollow!(company)
    if self.following?(company)
      remote_relationships.find_by_company_id(company).destroy
    end
  end
  
  
  
  
  
  
  
  
  
  
  
end
