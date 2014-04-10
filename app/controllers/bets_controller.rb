class BetsController < ApplicationController
  before_action :set_bet, only: [:show, :update, :destroy, :close, :close_2, :stats]
  before_action :admin, only: [:show, :close, :close_2]
  before_action :ensure_user_is_admin, only: [:close, :close_2]
  before_action :authenticate_user!

  # GET /bets
  def index 
      @accepted_bets = Bet.accepted(current_user)
      @pending_bets =  Bet.pending(current_user)
      @closed_bets = Bet.closed(current_user)
  end

  # GET /bets/1
  def show
    @betters = User.participating(@bet)
    @position = Position.current(current_user, @bet)
  end

  # GET /bets/new
  def new
    @bet = Bet.new
  end

  # POST /bets
  # POST /bets.json
  def create
    @bet = Bet.new(bet_params)
    respond_to do |format|
      if @bet.save
        format.html { redirect_to new_bet_position_path(@bet) }
        format.html { render json: @bet, status: :created, location: @bet }
      else
        format.html { render action: "new" }
        format.json {render json: @bet.errors, status: unprocessable_entry }
      end
    end
  end

  #display page for admin to indicate winner
  def close
      @betters = User.participating(@bet)
  end

  #record winners, closed bet status, send mailers
  def close_2
    begin
      Position.transaction do 
        # set up a few key variables
        @winner = User.winner(params[:winner])
        @betters = User.participating(@bet)
        @losers = @betters.select {|better| better != @winner}

        #record winner in bets table
        @bet.update(winner_id: @winner.id)

        #update winner's position record
        p = Position.current(@winner, @bet)
        p.win = true
        p.status = "closed"
        @total_amount = @bet.amount * @losers.size
        p.money_earned = @total_amount
        p.money_lost = 0
        p.save


        #update losers' position records
        @losers.each do |better|
          p = Position.current(better, @bet)
          p.status = "closed"
          p.win = false
          p.money_earned = 0
          p.money_lost = @bet.amount
          p.save
        end
      end
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      flash[:error] = "Something went wrong while closing this bet. Please try again."
      redirect_to bet_path(@bet)
    end

    #create venmo link
    venmo_link = create_venmo_link(@bet.amount, @winner.email, @bet.description)

    #mail winner and losers
    BetNotifier.win_notification(@winner.email, @total_amount, @bet).deliver
    BetNotifier.payment_link(@losers, venmo_link, @bet, @winner.email, @total_amount).deliver

    redirect_to stats_path
  end

  private
    def set_bet
      @bet = Bet.find(params[:id])
    end
    
    def bet_params
      params.require(:bet).permit(:title, :description, :amount)
    end
    
    #link to be sent to losers of the bet
    def create_venmo_link(amount, payee, note, user = '')
      root_url = 'https://venmo.com/'
      params = URI.encode_www_form([
                                    ['txn', "pay"],
                                    ['recipients', "#{payee}"],
                                    ['amount', "#{amount}"],
                                    ['note', "#{note}"],
                                    ['audience', "private"]
                                   ])
      root_url  + "#{user}?" + params
    end

    def admin
      @admin = User.admin(@bet)
    end

    def ensure_user_is_admin
      if current_user != @admin
        flash[:error] = "Only the creator of the bet can close the bet."
        redirect_to bet_path(@bet)
      end
    end
end
