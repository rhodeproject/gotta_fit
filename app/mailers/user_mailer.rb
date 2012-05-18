class UserMailer < ActionMailer::Base
  default from: "therhodeproject@gmail.com"

  def new_user_confirmation(user)
    @user = user
    if Rails.env.development?
      address = "mhatch73@gmail.com"
      subject = "---Test--- Confirmation for user #{@user.email}"
    else
      address = @user.email
      subject = "TriFit Lab new user confirmation - #{@user.first_name} #{@user.last_name}"
    end

    mail(:to => address, :subject => subject)
  end
end
