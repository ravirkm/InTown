




class Company < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :prototype_key
  attr_accessible :email, :password, :password_confirmation, :remember_me,
									:contact_name, :company_name, :prototype_key
  has_many :relationships, :foreign_key => "company_id",
                           :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :users, :through => :relationships
  validates :company_name, :presence => true, :length => { :maximum => 50 }
  validates :contact_name, :presence => true, :length => { :maximum => 30 }
  validate :verify_prototype_key
	
  def self.search(search)
    if search
      find(:all, :conditions => ['company_name LIKE ?', "%#{search}%"])
    else
     find(:all)
    end
  end
	
	
    def verify_prototype_key
      errors.add(:prototype_key, "is invalid") if
        (prototype_key != '0b95372d68')
    end


end




# == Schema Information
#
# Table name: companies
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
#  company_name           :string(255)
#  contact_name           :string(255)
#

