class InvitationsController < ApplicationController

  def new
    
  end

  def create
    @friends = params[:friends].split(",")
    @friends.each do |email|
      friend = User.find_by(email: email.strip)
      if friend
        #create join entry
        Position.create(user_id: friend.id, bet_id: params[:bet_id], status: "pending", admin: false )
      else
        #send email invite
      end
    end
    redirect_to bets_path
  end
end
