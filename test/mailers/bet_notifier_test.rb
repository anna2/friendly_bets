require 'test_helper'

class BetNotifierTest < ActionMailer::TestCase
  fixtures :bets, :users

  test "payment_link" do
    mail = BetNotifier.payment_link([users(:one)], "venmo_link", bets(:one), "winner@abc.com", 123)
    assert_equal "One of your Friendly Bets has closed!", mail.subject
    assert_equal [users(:one).email], mail.to
    assert_equal ["friendly_bets@example.com"], mail.from
  end

  test "win_notification" do
    mail = BetNotifier.win_notification("winner@abc.com", 123, bets(:one), )
    assert_equal "Congrats, you just won a Friendly Bet!", mail.subject
    assert_equal ["winner@abc.com"], mail.to
    assert_equal ["friendly_bets@example.com"], mail.from
  end

end
