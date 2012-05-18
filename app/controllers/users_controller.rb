class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash["success"] = "Welcome #{@user.first_name}!"
      redirect_to @user
    end
  end

  def index

  end

  def show
    @user = User.find(params[:id])
  end

end
