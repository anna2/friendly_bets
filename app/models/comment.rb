class Comment < ActiveRecord::Base
  has_attached_file :photo, :styles => {:medium => "300x300>"}
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  belongs_to :user
  belongs_to :bet
end
