class UserMailer < ActionMailer::Base
  default from: "therhodeproject@gmail.com"

  def new_user_confirmation(user)
    @user = user
    if Rails.env.development?
      address = "mhatch73@gmail.com"
      subject = "---Test--- Confirmation for user #{@user.email}"
      @url = "http://localhost:3000"
    else
      address = @user.email
      subject = "TriFit Lab new user confirmation - #{@user.first_name} #{@user.last_name}"
      @url = "http://gottafit.com"
    end

    mail(:to => address, :subject => subject)
  end

  def user_slot_sign_up(user, slot)
    @user = user
    @slot = slot


    if Rails.env.development?
      address = "mhatch73@gmail.com"
      subject = "-----Test------ Multi-rider signup"
    else
      address = @user.email
      subject = "TriFit Lab Multi-rider signup"
    end

    mail(:to => address, :subject => subject)
  end
end
