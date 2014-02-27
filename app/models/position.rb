class Position < ActiveRecord::Base
  belongs_to :bet
  belongs_to :user

  validates :position, presence: true
    
end
