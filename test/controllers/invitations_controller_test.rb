require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase

  setup do
    sign_in users(:one)
  end

  test "should get new" do
    get :new, bet_id: bets(:one).id
    assert_response :success
  end

  test "should create new position" do
    assert_difference("Position.count", +1) do
      post :create, { bet_id: bets(:one).id, friends: users(:two).email }
    end
    assert_redirected_to bets_path
  end

  test "should send invitation email" do
    assert_difference("ActionMailer::Base.deliveries.size", +1) do
      post :create, { bet_id: bets(:one).id, friends: "nonmember@test.com" }
    end
  end

end
