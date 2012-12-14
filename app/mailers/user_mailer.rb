class UserMailer < ActionMailer::Base
  default :from => Figaro.env.email_from
  default :reply_to => Figaro.env.email_reply_to

  def nightly_user_count(users)
    @users = users
    mail(:to => 'matthew.hatch@rhodeproject.com', :subject => "User count")
  end

  def wait_list_notice(user, slot)
    @user = user
    @slot = slot
    if Rails.env.development?
      address = "mhatch73@gmail.com"
      subject = "---Test-#{@user.email}-- TriFit Lab - A spot has opened up!"
    else
      address = @user.email
      subject = "TriFit Lab - A spot has opened up!"
    end
    mail(:to => address, :subject => subject)
  end

  def reminder_email(user, slot)
    @user = user
    @slot = slot
    address = @user.email
    subject = "TriFit Lab - TriFit Lab Reminder!"
    mail(:to => address, :subject => subject)
  end

  def admin_task(taskname, count)
    @taskname = taskname
    @count = count
    mail(:to => "matthew.hatch@rhodeproject.com", :subject => "gotta fit reminder")
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

  def password_reset(user)
    @user = user
    address = @user.email
    subject = "Password reset request for #{@user.first_name}"
    if Rails.env.development?
      url = "http://localhost:3000"
    else
      url = "https://www.gottafit.com"
    end
    mail(:to => address, :subject => subject)
  end
end
