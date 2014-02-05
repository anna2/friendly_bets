class SiteController < ApplicationController
  def index
    if current_user
      @bets = current_user.bets
    end
  end

  def help
    
  end
end
