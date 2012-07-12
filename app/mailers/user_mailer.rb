class UserMailer < ActionMailer::Base
  default from: "therhodeproject@gmail.com"

  def wait_list_notice(user, slot)
    if Rails.env.development?
      address = "mhatch73@gmail.com"
      subject = "---Test--- TriFit Lab - A spot has opened up!"
    else
      address = @user.email
      subject = "TriFit Lab - A spot has opened up!"
    end
    @user = user
    @slot = slot
    mail(:to => address, :subject => subject)
  end

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

  def new_user_notice(user)
    @user = user
    @count = User.count
    mail(:to => "matthew.hatch@rhodeproject.com", :subject => "Another User -- #{@user.first_name}")
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
