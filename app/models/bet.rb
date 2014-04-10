class Bet < ActiveRecord::Base
  has_many :positions, dependent: :destroy
  has_many :users, through: :positions
  has_many :comments

  validates :title, :description, :amount, presence: true
  validates :amount, numericality: {greater_than_or_equal_to: 0.01}

  scope :accepted, lambda { |user | joins(:positions).where(positions: {user_id: user.id, status: "accepted"}) }
  scope :pending, lambda { |user| joins(:positions).where(positions: {user_id: user.id, status: "pending"}) }
  scope :closed, lambda { |user| joins(:positions).where(positions: {user_id: user.id, status: "closed"})}
  scope :all_wins_for_user, lambda { |user| where(winner_id: user.id)}
            
end
