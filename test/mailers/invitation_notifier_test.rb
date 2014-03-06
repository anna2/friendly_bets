require 'test_helper'

class InvitationNotifierTest < ActionMailer::TestCase
  fixtures :bets

  test "invited" do
    mail = InvitationNotifier.invited("to@example.org", "better1@example.com", bets(:one))

    assert_equal "better1@example.com invited you to Friendly Bets!", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["friendlybetsnotification@gmail.com"], mail.from
  end

end
