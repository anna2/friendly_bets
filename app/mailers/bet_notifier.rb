class BetNotifier < ActionMailer::Base
  default from: "friendly_bets@example.com"

  def payment_link(losers, link, bet, payee, total_amount)
    @payee = payee
    @link = link
    @bet = bet
    @total_amount = total_amount
    
    losers.each do |l|
      mail to: l.email, subject: "One of your Friendly Bets has closed!"
    end
  end

  def win_notification(payee, total_amount, bet)
    @total_amount = total_amount
    @bet = bet

    mail to: payee, subject: "Congrats, you just won a Friendly Bet!"
  end
end
