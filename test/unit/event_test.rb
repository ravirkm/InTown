require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

