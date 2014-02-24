class InvitationNotifier < ActionMailer::Base
  default from: "friendly_bets@example.com"

  def invited(invitee, inviter, bet)
    @inviter = inviter
    @bet = bet

    mail to: invitee, subject: "#{inviter} invited you to Friendly Bets!"
  end
end
