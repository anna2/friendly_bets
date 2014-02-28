require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  test "should not register user without unique email" do
    user = User.new(
                    email: "test@test.com",
                    password: "password",
                    password_confirmation: "password")
    assert !user.save
  end

  test "should not register user without matching password confirmation" do
    user = User.new(
                    email: "unique@test.com",
                    password: "password",
                    password_confirmation: "notamatch")
    assert !user.save
  end
  
end
