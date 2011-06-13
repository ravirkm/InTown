# == Schema Information
#
# Table name: relationships
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#








class Relationship < ActiveRecord::Base
  attr_accessible :company_id
  belongs_to :user
  belongs_to :company
  validates :user_id, :presence => true
  validates :company_id, :presence => true



end

