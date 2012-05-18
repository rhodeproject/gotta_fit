class UserObserver < ActiveRecord::Observer
  def after_create(user)
    #Send Account Activation Emails
    :create_code
    UserMailer.delay.new_user_confirmation(user)
  end

  private

  def create_code
    self.confirm_code = SecureRandom.urlsafe_base64
  end

end
