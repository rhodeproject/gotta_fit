class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user.active?
      if user  && user.authenticate(params[:session][:password])
        sign_in user
        flash[:success] = "Welcome back #{user.first_name}"
        redirect_back_or root_path
      else
        # Create an error message and re-render the signin form.
        flash.now[:error] = 'Invalid email/password combination' # Not quite right!
        render 'new'
      end
    else
      flash[:waring] = "Account inactive, please check your inbox for activation email"
      redirect_back_or root_path
    end

  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
