class SiteController < ApplicationController
  def index
    if current_user
      @accepted_bets = Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "accepted"})
      @pending_bets =  Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "pending"})
      @closed_bets = Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "closed"})
    end
  end

  def help
    
  end
end
