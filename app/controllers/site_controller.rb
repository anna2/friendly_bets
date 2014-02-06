class SiteController < ApplicationController
  def index
    if current_user
      @accepted_bets = Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "accepted"})
      @pending_bets =  Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "pending"})
    end
  end

  def help
    
  end
end
