require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset"
  user = Factory(:user)
  visit signin_path
  click_link "password"
  fill_in "Email", :with => user.email
  click_button "Reset Password"
end

