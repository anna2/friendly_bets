require 'test_helper'

class BetsControllerTest < ActionController::TestCase
  fixtures :bets, :users, :positions

  setup do
    sign_in users(:one)
    @bet = bets(:one)
    @update = {
      amount: 12.00,
      description: "update text",
      title: "update test"
    }
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bet" do
    assert_difference('Bet.count') do
      post :create, bet: @update
    end

    assert_redirected_to new_bet_position_path(assigns(:bet))
  end

  test "should show bet" do
    get :show, id: @bet
    assert_response :success
  end

  test "should update bet" do
    patch :update, id: @bet, bet: { amount: @bet.amount, description: @bet.description, title: @bet.title }
    assert_redirected_to bet_path(assigns(:bet))
  end

  test "should destroy bet" do
    assert_difference('Bet.count', -1) do
      delete :destroy, id: @bet
    end

    assert_redirected_to bets_path
  end

  test "should show bet participants" do
    get :close, id: @bet.id
    assert_response :success
  end

  test "should update position statuses to closed" do
    assert_difference(Position.where(status: "closed")) do
      post :close_2, id: @bet.id, winner: users(:one).email
    end
    assert_redirected_to stats_path
  end

  test "should update 1 position win status to true" do
    assert_difference Position.where(win: true), +1 do
      post :close_2, id: @bet.id, winner: users(:one).email
    end
    assert_redirected_to stats_path
  end

  test "should update other position win statuses to false" do
    assert_difference Position.where(win: false), +1 do
      post :close_2, id: @bet.id, winner: users(:one).email
    end
    assert_redirected_to stats_path
  end

  test "should update winner in bet record" do
    assert_difference Bet.where(winner_id: nil), -1 do
      post :close_2, id: @bet.id, winner: users(:one).email
    end
    assert_redirected_to stats_path
  end

  test "should mail winners and losers" do
    assert_difference 'ActionMailer::Base.deliveries.size', +2  do
      post :close_2, id: @bet.id, winner: users(:one).email
    end
  end
end
