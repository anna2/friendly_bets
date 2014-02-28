class InvitationTest < ActiveSupport::TestCase

  test "should create inivitation if friends are given" do
    i = Invitation.new("example@example.com, another@another.com")
    assert i.valid?
  end

  test "should not validate invitation without friends provided" do
    i = Invitation.new
    assert i.invalid?
  end
  
end
