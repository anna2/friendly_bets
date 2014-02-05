class Position < ActiveRecord::Base
  belongs_to :bet
  belongs_to :user
    
end
