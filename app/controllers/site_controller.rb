class SiteController < ApplicationController
  before_action :authenticate_user!, only: [:stats]
  def index

  end

  def help
    
  end

  def stats
    # money earned/lost bar chart
    @money_earned = 0
    Position.all_wins_for_user(current_user).each do |win|
      unless win.money_earned.nil?
        @money_earned += win.money_earned
      end
    end

    @money_lost = 0
    Position.all_losses_for_user(current_user).each do |loss|
      unless loss.money_lost.nil?
        @money_lost += loss.money_lost
      end
    end
    @data1 = {"Money earned" => @money_earned, "Money Lost" => @money_lost}

    # bets won/lost pie chart
    @bets_won = Bet.all_wins_for_user(current_user).size
    @bets_lost = Position.all_losses_for_user(current_user).size
    @bets_current = Position.ongoing_bets(current_user).size
    @data2 = { "Won" => @bets_won,
      "Lost" => @bets_lost,
      "Pending" => @bets_current }

    #create section for earnings over time
  end
end
