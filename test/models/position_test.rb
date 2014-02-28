class PositionTest < ActiveSupport::TestCase

  test "should not save without position" do
    p = Position.new
    assert p.invalid?
  end
  
  test "should save with position" do
    p = Position.new(position: "yes")
    assert p.valid?
  end
  
end
