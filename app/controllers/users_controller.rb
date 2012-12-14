class UsersController < ApplicationController
  before_filter :admin_check, :only => [:index, :destroy]
  before_filter :sign_in_check, :only => :index

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.confirm_code = SecureRandom.urlsafe_base64
    if @user.save
      flash["success"] = "Welcome #{@user.first_name}! Check you email in order to activate your account."
      UserMailer.new_user_notice(@user).deliver
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @users = User.order('last_name DESC')
  end

  def confirm()
    @user = User.find(params[:id])
    if @user.confirm_code == params[:confirm_code]
      @user.update_attribute('active', true)
      @user.update_attribute('confirm_code', nil)
      flash[:success] = "#{@user.first_name}, your account has been activated!"
      sign_in(@user)
      redirect_to @user
    else
      flash[:warning] = "User confirmation unsuccessful"
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])
    @rides = @user.slots.where('date >= ?', Date.today)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attribute(:admin, params[:user][:admin]) &&
        @user.update_attribute(:purchased_rides, params[:user][:purchased_rides]) &&
        @user.update_attribute(:email, params[:user][:email]) &&
        @user.update_attribute(:first_name, params[:user][:first_name]) &&
        @user.update_attribute(:last_name, params[:user][:last_name])
      flash[:success] = "User update successful!"
      redirect_to users_path
    else
      flash[:warning] = "There was an issue updating user"
      redirect_to users_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been removed!"
    redirect_to users_path
  end

  private

  def admin_check
    flash[:warning] = "You must be an administrator to perform this action" unless current_user.admin?
  end

  def sign_in_check
    flash[:warning] = "You are not signed in" unless signed_in?
  end
end
