require "minitest_helper"

describe "Users integration" do
  it "shows User's' name" do
    user = User.create!(first_name: "Test_First_Name",
                        last_name: "Test_Last_Name",
                        email: "me12@here.com",
                        password: "testpass",
                        password_confirmation: "testpass")
    visit user_path(user)
    page.text.must_include "Test_First_Name"
  end
end