require 'date'
require 'geocoder'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessor :prototype_key
  attr_accessible :email, :password, :password_confirmation, :remember_me, :address, :name,
		  :prototype_key, :radius
  
  has_many :authentications, :dependent => :destroy
  has_many :relationships, :dependent => :destroy
  has_many :companies, :through => :relationships                          
  validates :name, :presence => true, :length => { :maximum => 30 }
  validates :address, :presence => true
  validates :radius, :presence => true
  validate :verify_prototype_key
  geocoded_by :address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates


   
  def verify_prototype_key
	  if self.sign_in_count == 0
      errors.add(:prototype_key, "is invalid") if
        (prototype_key != '0b95372d68')
    end
  end

  def apply_omniauth(omniauth)
		self.email = omniauth['user_info']['email'] if email.blank?
		authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def build_from_remote(remote_user)
    self.email = remote_user[:email]
    self.address = remote_user[:address]
  end
  
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def update_with_password(params={})
    current_password = params.delete(:current_password) if !params[:current_password].blank?
    if params[:password].blank?
      params.delete(:password)
	  params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    result = if has_no_password?  || valid_password?(current_password)
    update_attributes(params) 
    else
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
	  self.attributes = params
	  false
    end
    clean_up_passwords
    result
  end

  def has_no_password?
	self.encrypted_password.blank?
  end
    
  def following?(company)
    if relationships.find_by_company_id(company.id).nil?
      return false
    else
      return true
    end
  end
  
  def follow!(company)
    unless self.following?(company)
      relationships.create!(:company_id => company.id)
    end
  end
		
  def num_following
    return self.companies.all.size
  end

	
  def unfollow!(company)
    if self.following?(company)
      relationships.find_by_company_id(company).destroy
    end
  end
  
  
  
end







# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#  address         :string(255)
#  admin                  :boolean         default(FALSE)
#  latitude               :float
#  longitude              :float
#

