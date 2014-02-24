require 'test_helper'

class BetNotifierTest < ActionMailer::TestCase
  test "payment_link" do
    mail = BetNotifier.payment_link
    assert_equal "Payment link", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "win_notification" do
    mail = BetNotifier.win_notification
    assert_equal "Win notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
