require 'test_helper'

class RemoteUsersControllerTest < ActionController::TestCase
  test "should get link" do
    get :link
    assert_response :success
  end

end
