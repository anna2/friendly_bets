require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
 fixtures :users, :bets

  test "login and browse" do
    https!
    get "/users/sign_in"
    assert_response :success

    post_via_redirect "/users/sign_in", 'user[email]' => users(:one).email, 'user[password]' => "password"
     assert_equal '/', path

    get '/bets'
    assert_response :success
    assert assigns(:accepted_bets)
  end


  test "login, create a bet, invite friends" do
    https!
    get "/users/sign_in"
    assert_response :success

    post_via_redirect "/users/sign_in", 'user[email]' => users(:one).email, 'user[password]' => "password"
    assert_equal '/', path

    get '/bets/new'
    assert_response 200
    post '/bets', 'bet[title]' => "title", 'bet[description]' => "desc", 'bet[amount]' => 123
    bet_id =  assigns["bet"].id
    follow_redirect!
    assert_equal "/bets/#{bet_id}/positions/new", path
   
    post_via_redirect "/bets/#{bet_id}/positions", 'position[position]' => "yes"
    assert_equal "/bets/#{bet_id}/invitations/new", path

    post_via_redirect "/bets/#{bet_id}/invitations", 'friends' => "sample@sample.com, another@another.com"
    assert_equal '/bets', path
    
  end


end
