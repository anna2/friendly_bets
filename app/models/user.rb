class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :confirmable

  has_many :positions, dependent: :destroy
  has_many :bets, through: :positions
  has_many :comments

  #temporarily skip required confirmation of email
  #remove in production
  protected
  def confirmation_required?
    false
  end
end
