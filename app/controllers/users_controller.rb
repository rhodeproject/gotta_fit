class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.confirm_code = SecureRandom.urlsafe_base64
    if @user.save
      sign_in @user
      flash["success"] = "Welcome #{@user.first_name}!"
      redirect_to @user
    end
  end

  def index

  end

  def confirm()
    @user = User.find(params[:id])
    if @user.confirm_code == params[:confirm_code]
      @user.update_attribute('active', true)
      @user.update_attribute('confirm_code', nil)
      flash[:success] = "#{@user.first_name}, your account has been activated!"
      redirect_to @user
    else
      flash[:warning] = "User confirmation unsuccessful"
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
