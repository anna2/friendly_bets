class PositionsController < ApplicationController
  def new
    @position = Position.new
  end

  def create
    user = User.find(current_user.id)
    bet = params[:bet_id]
    position = Position.find_by(bet_id: bet, user_id: current_user.id)
    position.update(status: "accepted")
    if Position.where(bet_id: bet).size == 0
      position.update(admin: true)
    else
      position.update(admin: false)
    end
    position.update(position: params[:position][:position])
    redirect_to new_bet_invitation_path
  end
end
