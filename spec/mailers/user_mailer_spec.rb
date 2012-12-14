require "spec_helper"

describe UserMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @user = mock_model(User, :first_name => "Test", :last_name => "User" ,:email => "foo@bar.com")
    @user.stub!(:confirm_code).and_return(SecureRandom.urlsafe_base64)
    @user.stub!(:reset_token).and_return(SecureRandom.urlsafe_base64)
    @user.stub!(:name).and_return("#{@user.first_name} #{@user.last_name}")

    @slot = mock_model(Slot,
                       :description => "test slot",
                       :date => Date.today.to_s,
                       :start_time => "1pm",
                       :end_time => "2pm",
                       :slots => 2)

  end

  describe "wait_list_notice" do
    before do
      @mail = UserMailer.wait_list_notice(@user, @slot)
    end

    it "should be from paincave@rhodeproject.com" do
      @mail.from.should eq(["paincave@rhodeproject.com"])
    end

    it "should have reply_to address of trigitlab@ttbikefit.com" do
      @mail.reply_to.should eq(["trifitlab@ttbikefit.com"])
    end

    it "should have a subject that contains a spot has opened up" do
      @mail.subject.should contain("A spot has opened up")
    end

    describe "email body" do

      it "should contain the users name" do
        @mail.body.should contain(@user.first_name)
      end

      it "should contain the slot description" do
        @mail.body.should contain("Ride: #{@slot.description}")
      end

      it "should contain the slot date" do
        @mail.body.should contain("Day: #{@slot.date}")
      end

      it "should contain the slot start time" do
        @mail.body.should contain("Start Time: #{@slot.start_time}")
      end

      it "should contain the slot end time" do
        @mail.body.should contain("End Time: #{@slot.end_time}")
      end

    end

  end

  describe "nightly_user_count" do
    before do
      @user2 = mock_model(User, :first_name => "Test", :last_name => "User 2",:email => "foo2@bar.com")
      @user2.stub!(:name).and_return("#{@user2.first_name} #{@user2.last_name}")
      @users = Array.new
      @users << @user
      @users << @user2
      @mail = UserMailer.nightly_user_count(@users)
    end

    it "should be from paincave@rhodeproject.com" do
      @mail.from.should eq(["paincave@rhodeproject.com"])
    end

    it "should have a reply_to address of trifitlab@ttbikefit.com" do
      @mail.reply_to.should eq(["trifitlab@ttbikefit.com"])
    end

    it "should be sent to matthew.hatch@rhodeproject.com" do
      @mail.to.should eq(["matthew.hatch@rhodeproject.com"])
    end


    describe "email body" do
      it "should contain all users name" do
        @mail.body.should contain(@user.first_name)
        @mail.body.should contain(@user2.first_name)
      end

      it "should contain all users email address" do
        @mail.body.should contain(@user.email)
        @mail.body.should contain(@user2.email)
      end
    end

  end

  describe "reminder_email" do

    before do
      @mail = UserMailer.reminder_email(@user, @slot)
    end

    it "should be from paincave@rhodeproject.com" do
      @mail.from.should eq(["paincave@rhodeproject.com"])
    end

    it "should be to the correct user" do
      @mail.to.should contain(@user.email)
    end

    describe "email body" do

      it "should contain users name" do
        @mail.body.should contain(@user.first_name)
      end

      it "should contain slot description" do
        @mail.body.should contain(@slot.description)
      end

      it "should contain slot start time" do
        @mail.body.should contain(@slot.start_time)
      end

      it "should contain slot end time" do
        @mail.body.should contain(@slot.end_time)
      end

      it "should contain slot date" do
        @mail.body.should contain(@slot.date)
      end

    end

  end

  describe "new_user_confirmation" do

    before do
      @mail = UserMailer.new_user_confirmation(@user)
    end

    it "should be sent to the new user" do
      @mail.to.should contain(@user.email)
    end

    it "should be sent from the value configured in the application.yml" do
      @mail.from.should contain(Figaro.env.email_user)
    end

    it "should have a subject that contains confirmation" do
      @mail.subject.should contain("confirmation")
    end

    describe "email body" do

      it "should contain confirmation token" do
        @mail.body.should contain(@user.confirm_code)
      end

    end
  end

  describe "user_slot_sign_up" do
    before do
      @mail = UserMailer.user_slot_sign_up(@user, @slot)
    end

    it "should be from value configured in applicaiton.yml" do
      @mail.from.should contain(Figaro.env.email_user)
    end

    it "should be to user signing up" do
      @mail.to.should contain(@user.email)
    end

    describe "email body" do

      it "should contain the name of the slot" do
        @mail.body.should contain("Ride: #{@slot.description}")
      end

      it "should contain the date" do
        @mail.body.should contain("Day: #{@slot.date}")
      end

      it "should contain the start time" do
        @mail.body.should contain("Start Time: #{@slot.start_time}")
      end

      it "should contain the end time" do
        @mail.body.should contain("End Time: #{@slot.end_time}")
      end

    end

  end

  describe "password_reset" do
    before do
      @mail = UserMailer.password_reset(@user)
    end

    it "should contain user first name in the subject" do
      @mail.subject.should contain(@user.first_name)
    end

    it "should be from user configured in the application.yml" do
      @mail.from.should contain(Figaro.env.email_user)
    end

    it "should be to user's email" do
      @mail.to.should contain(@user.email)
    end

    describe "email body" do

      it "should contain reset token" do
        @mail.body.should contain(@user.reset_token)
      end

    end
  end
end
