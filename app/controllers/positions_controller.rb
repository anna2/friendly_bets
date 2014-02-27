class PositionsController < ApplicationController
  before_action :set_bet, only: [:create]
  before_action :authenticate_user!

  def new
    @position = Position.new
  end

  def create
    @position = Position.new(position: params[:position][:position], bet_id: params[:bet_id], user_id: current_user.id, status: "accepted")
    respond_to do |format|
      if @position.save
        if Position.where(bet_id: params[:bet_id]).size == 1
          @position.update(admin: true)
        else
          @position.update(admin: false)
        end
        format.html { redirect_to new_bet_invitation_path(@bet) }
        format.json { render json: @position, status: :created, location: @position }
      else
        format.html { render action: "new" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @position = Position.find(params[:id])
    @position.destroy
    redirect_to root_path
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

end
