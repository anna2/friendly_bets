class PositionsController < ApplicationController
  before_action :set_bet, only: [:create]
  before_action :authenticate_user!

  def new
    @position = Position.new
  end

  def create
    # do not allow overwriting of old positions
    if Position.find_by(bet_id: @bet.id, user_id: current_user.id, status: "accepted")
      flash[:error] = "You already have a position on this bet."
      redirect_to bet_path(@bet)
    else
      #handle position on newly-accepted bets
      if Position.find_by(bet_id: @bet.id, user_id: current_user.id, status: "pending")
        @position = Position.find_by(bet_id: @bet.id, user_id: current_user.id)
        @position.update(position: params[:position][:position])
        @position.update(status: "accepted")
        @position.update(admin: false)
      else
        # handle position on newly-created bet
        @position = Position.new(position: params[:position][:position], bet_id: @bet.id, user_id: current_user.id, status: "accepted", admin: true)
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
    end

    def destroy
      @position = Position.find(params[:id])
      @position.destroy
      redirect_to bets_path
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
