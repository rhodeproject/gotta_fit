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
      UserMailer.new_user_notice(@user).deliver
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    if signed_in? && current_user.admin?
      @users = User.paginate(page: params[:page], :per_page => 10)
    else
      flash[:warning] = "You must be an administrator to perform this action"
    end
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
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "#User update successful!"
      redirect_to users
    else
      flash[:warning] = "There was an issue updating user"
      redirect_to users
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been removed!"
    redirect_to users_path
  end
end
