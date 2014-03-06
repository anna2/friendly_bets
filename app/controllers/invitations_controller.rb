class InvitationsController < ApplicationController
  before_action :set_bet, only: [:create]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(params[:friends])
    respond_to do |format|
      if @invitation.valid?
        emails = @invitation.friends.split(/[\s,]+/)
        emails.each do |email|
          friend = User.find_by(email: email.strip.downcase)
            if friend
              unless (friend == current_user) || (Position.where(user_id: friend.id, bet_id: @bet.id).size > 0)
              #create join entry
              p = Position.new(user_id: friend.id, bet_id: @bet.id, status: "pending", admin: false)
              p.save(validate: false)
                end
            else
              #send email invite
              InvitationNotifier.invited(email.strip, current_user.email, Bet.find(params[:bet_id])).deliver
            end
        end
        format.html { redirect_to bets_path }
        format.json { render json: @invitation, status: :created, location: @invitation }
      else
        format.html { render action: "new" }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end      
    end
  end

  private

  def set_bet
    @bet = Bet.find(params[:bet_id])
  end

  def inv_params
    params.require(:friends)
  end

end
