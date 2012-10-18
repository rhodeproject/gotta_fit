class PasswordResetsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    flash[:information] = "Email has been sent with reset instruction"
    redirect_to root_url
  end

  def edit
    @user = User.find_by_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      flash[:warning] = "Password reset has expired."
      redirect_to root_path
    elsif @user.update_attributes(params[:user])
      flash[:success] = "Password has been reset"
      redirect_to root_path
    else
      render :edit
    end
  end
end
