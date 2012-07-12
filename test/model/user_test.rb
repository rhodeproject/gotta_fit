require "minitest_helper"

class UserTest < MiniTest::Unit::TestCase
  def test_to_param
    user = User.create!(first_name: "Test_First_Name",
                        last_name: "Test_Last_Name",
                        email: "me5@here.com",
                        password: "testpass",
                        password_confirmation: "testpass")
    assert_equal "#{user.id}-test_first_name", user.to_param
  end
end