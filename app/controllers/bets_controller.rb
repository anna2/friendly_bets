class BetsController < ApplicationController
  before_action :set_bet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /bets
  # GET /bets.json
  def index
    if current_user
      @accepted_bets = Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "accepted"})
      @pending_bets =  Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "pending"})
    end
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
    @admin = User.joins(:positions).where(positions: {bet_id: params[:id], admin: true}).take
    @betters = User.joins(:positions).where(positions: {bet_id: params[:id]})
  end

  # GET /bets/new
  def new
    @bet = Bet.new
  end

  # GET /bets/1/edit
  def edit
  end

  # POST /bets
  # POST /bets.json
  def create
    @user = User.find(current_user.id)
    @bet = @user.bets.build(bet_params)
    @user.save
    @bet.save
    redirect_to new_bet_position_path(@bet)
  end

  # PATCH/PUT /bets/1
  # PATCH/PUT /bets/1.json
  def update
    respond_to do |format|
      if @bet.update(bet_params)
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet.destroy
    respond_to do |format|
      format.html { redirect_to bets_url }
      format.json { head :no_content }
    end
  end

  def close
    @betters = User.joins(:positions).where(positions: {bet_id: params[:id]})
  end

  def close_2
    #change status to closed
    @betters = User.joins(:positions).where(positions: {bet_id: params[:id]})
    @betters.each do |better|
      p = Position.find_by(bet_id: params[:id], user_id: better.id)
      p.update(status: "closed")
    end
    #create venmo link
    @bet = Bet.find(params[:id])
    amount = @bet.amount
    payee = params[:winner]
    note = @bet.description
    venmo_link = create_venmo_link(amount, payee, note)

    redirect_to stats_bet_path
  end

  def stats
    @bet
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bet
      @bet = Bet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bet_params
      params.require(:bet).permit(:title, :description, :amount)
    end
    
    #link to be sent to losers of the bet
    def create_venmo_link(amount, payee, note, user = '')
      root_url = 'https://venmo.com/'
      params = URI.encode_www_form([
                                    ['type', "pay"],
                                    ['recipients', "#{payee}"],
                                    ['amount', "#{amount}"],
                                    ['note', "#{note}"],
                                    ['audience', "private"]
                                   ])
      root_url  + "#{user}?" + params
    end
end
