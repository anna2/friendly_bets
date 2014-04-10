class Position < ActiveRecord::Base
  belongs_to :bet
  belongs_to :user

  validates :position, presence: true

  scope :current, lambda { |user, bet| where(user_id: user.id, bet_id: bet.id).first }
  scope :on_current_bet, lambda { |bet| where(bet_id: bet.id) }
  scope :closed, lambda { where(status: "closed") }
  scope :won, lambda { where(win: true) }
  scope :lost, lambda { where(win: false) }
  scope :not_closed, lambda { where(win: nil) }
  scope :by_user, lambda { |user| where(user_id: user.id) }
    
  def self.all_losses_for_user(user)
    self.by_user(user).closed.lost
  end

  def self.all_wins_for_user(user)
    self.by_user(user).closed.won
  end

  def self.ongoing_bets(user)
    self.by_user(user).not_closed
  end
  
end
