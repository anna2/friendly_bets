require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get help page" do
    get :help
    assert_response :success
  end

end
