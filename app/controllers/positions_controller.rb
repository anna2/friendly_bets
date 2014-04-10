class PositionsController < ApplicationController
  before_action :set_bet
  before_action :set_position, only: [:destroy]
  before_action :authenticate_user!

  def new
    @position = Position.new
  end

  def create
    # handle position on newly-created bet
    if new_bet_requires_position?
      @position = Position.new(position: pos_params[:position],
                               bet_id: @bet.id,
                               user_id: current_user.id,
                               status: "accepted",
                               admin: true)

    #handle position on newly-accepted bets
    elsif pending_bet_requires_position?
      @position = Position.current(current_user, @bet)
      @position.status = "accepted"
      @position.position = pos_params[:position]
      @position.admin = false
    else 
      flash[:error] = "You already have a position on this bet."
      redirect_to bet_path(@bet)
    end
    respond_to do |format|
      if @position.save
        format.html { redirect_to new_bet_invitation_path(@bet) }
        format.json { render json: @position, status: :created, location: @position }
      else
        format.html { render action: "new" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if user_has_set_position?
      flash[:error] = "You cannot exit a bet after creating a position on it."
      redirect_to bet_path(@bet)
    else
      @position.destroy
      redirect_to bets_path
    end
  end


  private

  def set_bet
    @bet = Bet.find(params[:bet_id])
  end

  def set_position
    @position = Position.find(params[:id])
  end

  def pos_params
    params.require(:position)
  end

  def pending_bet_requires_position?
    Position.current(current_user, @bet).status == "pending"
  end

  def new_bet_requires_position?
    Position.on_current_bet(@bet).size == 0
  end

  def user_has_set_position?
    !Position.current(current_user, @bet).position.nil?
  end
end
