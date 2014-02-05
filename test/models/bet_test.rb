require 'test_helper'

class BetTest < ActiveSupport::TestCase
  test "bet amount must be positive" do
    bet = Bet.new(title: "Test", description: "test")
    bet.amount = 0
    assert bet.invalid?

    bet.amount = -1
    assert bet.invalid?
  end

  test "bet must have title" do
    bet = Bet.new(description: "test", amount: 12)
    assert bet.invalid?
  end
end
