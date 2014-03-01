require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  fixtures :bets, :users

  test "should create comment" do
    sign_in users(:one)
    assert_difference 'Comment.count', +1 do
      post :create, { bet_id: bets(:one).id, comment: { text: "text", photo: nil }}
    end
    assert_redirected_to bet_path(bets(:one))
  end
end
