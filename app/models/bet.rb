class Bet < ActiveRecord::Base
  has_many :positions, dependent: :destroy
  has_many :users, through: :positions
  has_many :comments

  validates :title, :description, :amount, presence: true
  validates :amount, numericality: {greater_than_or_equal_to: 0.01}

  attr_reader :status
            
end
