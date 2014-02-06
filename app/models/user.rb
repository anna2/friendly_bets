class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_many :positions, dependent: :destroy
  has_many :bets, through: :positions

end
