Feature: Password Reset

  So I don't get locked out
  as a customer
  I want to be be able to reset my own password

  Scenario:
    Given a user with forgotten password
    When I visit password reset link and fill in my email address
    Then I should be able to send a password reset email to myself

