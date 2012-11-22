Given /^a user with forgotten password$/ do
  @user = Factory(:user)
end

When /^I visit password reset link and fill in my email address$/ do
  visit '/password_resets/new'
  fill_in  "Email", :with => @user.email
  click_button "Reset"
end

Then /^I should be able to send a password reset email to myself$/ do
  pending # express the regexp above with the code you wish you had
end