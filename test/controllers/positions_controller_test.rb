require 'test_helper'

class PositionsControllerTest < ActionController::TestCase
  fixtures :bets, :users
  
  setup do
    sign_in users(:one)
  end

  test "should get new position" do
    get :new, bet_id: bets(:one).id
    assert_response :success
  end

  test "should create position" do
    assert_difference("Position.count") do
      post :create, { bet_id: bets(:one).id, position: { position: "text" } }
    end
  end

  
end
