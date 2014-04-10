class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :confirmable

  has_many :positions, dependent: :destroy
  has_many :bets, through: :positions
  has_many :comments

  validates_uniqueness_of :email, case_sensitive: false

  scope :participating, lambda { |bet| joins(:positions).where(positions: {bet_id: bet.id, status: "accepted"}) }
  scope :admin, lambda { |bet| joins(:positions).where(positions: {bet_id: bet.id, admin: true}).take }
  scope :winner, lambda { |email| find_by(email: email) }

  #temporarily skip required confirmation of email
  #remove in production
  protected
  def confirmation_required?
    false
  end
end
