require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "should save a comment" do
    c = Comment.new(
                    photo_file_name: "kitty.jpg", 
                    photo_content_type: "image/jpeg", 
                    photo_file_size: 421620,  
                    text: "t2", 
                    user_id: 2, 
                    bet_id: 4
                    )
    assert c.save
  end

  test "attachment must be an image file" do
    c = Comment.new(photo_file_name: "name.jpg",
                    photo_content_type: "image/jpeg",
                    photo_file_size: 1024,
                    text: "text",
                    user_id: 1,
                    bet_id: 1
                    )
    assert c.save

    c = Comment.new(photo_file_name: "name",
                    photo_content_type: "text",
                    photo_file_size: 1024,
                    text: "text",
                    user_id: 1,
                    bet_id: 1
                    )
    assert !c.save
  end

end
