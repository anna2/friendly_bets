class Invitation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :friends

  validates :friends, presence: { message: "email field cannot be blank" }

  def initialize(friends = "")
    @friends = friends
  end

  def persisted?
    false
  end

end
