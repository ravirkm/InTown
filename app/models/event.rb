require 'geocoder'


class Event < ActiveRecord::Base
  attr_accessible :date, :address
  belongs_to :company
  validates :company_id, :presence => true
  validates :date, :presence => true
  validates :address, :presence => true
  default_scope :order => 'events.date'
  geocoded_by :address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
end






# == Schema Information
#
# Table name: events
#
#  id         :integer         not null, primary key
#  company_id :integer
#  date       :string(255)
#  address    :string(255)
#  coords     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  latitude   :float
#  longitude  :float
#

