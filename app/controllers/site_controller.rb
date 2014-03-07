class SiteController < ApplicationController
  def index

  end

  def help
    
  end

  def stats
    if current_user
      # money earned/lost bar chart
      @money_earned = 0
      Position.where(status: "closed", win: true).each do |win|
        @money_earned += win.money_earned
      end

      @money_lost = 0
      Position.where(status: "closed", win: false).each do |loss|
        unless loss.money_lost.nil?
          @money_lost += loss.money_lost
        end
      end
      @data1 = {"Money earned" => @money_earned, "Money Lost" => @money_lost}

      # bets won/lost pie chart
      @bets_won = Bet.where(winner_id: current_user.id).size
      @bets_lost = Position.where(user_id: current_user.id, win: false).size
      @bets_current = Position.where(user_id: current_user.id, win: nil).size
      @data2 = { "Won" => @bets_won, "Lost" => @bets_lost, "Pending" => @bets_current}

      #earnings over time
    end
  end
end
