class BetsController < ApplicationController
  before_action :set_bet, only: [:show, :edit, :update, :destroy, :close_2, :stats]
  before_action :authenticate_user!

  # GET /bets
  # GET /bets.json
  def index
    if current_user
      @accepted_bets = Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "accepted"})
      @pending_bets =  Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "pending"})
      @closed_bets = Bet.joins(:positions).where(positions: {user_id: current_user.id, status: "closed"})
    end
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
    @admin = User.joins(:positions).where(positions: {bet_id: params[:id], admin: true}).take
    @betters = User.joins(:positions).where(positions: {bet_id: params[:id], status: "accepted"})
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

  #display page for admin to indicate winner
  def close
    @betters = User.joins(:positions).where(positions: {bet_id: params[:id]})
  end

  #record winners, closed bet status, send mailers
  def close_2
    #change status to closed
    @betters = User.joins(:positions).where(positions: {bet_id: params[:id]})
    @losers = @betters.select {|better| better.email != params[:winner]}
    @losers.each do |better|
      p = Position.find_by(bet_id: params[:id], user_id: better.id)
      p.update(status: "closed")
      p.update(win: false)
    end

    #record winner in bets table and positions table
    @bet.update(winner_id: User.find_by(email: params[:winner]).id)
    p = Position.find_by(bet_id: params[:id], user_id: User.where(email: params[:winner]))
    p.update(win: true)

    #create venmo link
    @bet = Bet.find(params[:id])
    amount = @bet.amount
    total_amount = amount * (@losers.size)
    payee = params[:winner]
    note = @bet.description
    venmo_link = create_venmo_link(amount, payee, note)

    #mail winner and losers
    BetNotifier.win_notification(payee, total_amount, @bet).deliver
    BetNotifier.payment_link(@losers, venmo_link, @bet, payee, total_amount).deliver

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
                                    ['txn', "pay"],
                                    ['recipients', "#{payee}"],
                                    ['amount', "#{amount}"],
                                    ['note', "#{note}"],
                                    ['audience', "private"]
                                   ])
      root_url  + "#{user}?" + params
    end
end
