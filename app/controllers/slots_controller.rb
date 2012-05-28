class SlotsController < ApplicationController
  def new
    @slot = Slot.new
  end

  def edit

  end

  def update
    if params[:commit] == "Join Session"
      if signed_up?
        flash[:warning] = "you are already signed up for this session"
        redirect_to @slot
      else
        @slot = Slot.find(params[:id])
        add_user_to_slot
        redirect_to @slot
      end
    end
    if params[:commit] == "Leave Session"
      if signed_up?
        remove_user_from_slot
        redirect_to @slot
      else
        flash[:notice] = "You are not signed up"
        redirect_to @slot
      end

    end
  end

  def create
    if current_user.admin?
      @slot = Slot.new(params[:slot])
      if @slot.save
        flash[:success] = "New rider session created"
        redirect_to slots_path
      else
        flash[:error] = "There was an issue creating the session"
        redirect_to new_slot_path
      end
    else
      flash[:waring] = "You must be the sight admin to add sessions"
    end
  end

  def destroy
  end

  def index
    if signed_in?
      @slots = Slot.all(:order => "date, start_time DESC")
    else
      flash[:warning] = "You must be signed in to view sessions"
      redirect_to root_path
    end
  end

  def show
    if signed_in?
      @slot = Slot.find(params[:id])
      @riders = @slot.users
    else
      flash[:warning] = "You must be signed in to view this!"
      redirect_to root_path
    end

  end

  private

  def add_user_to_slot
    @slot = Slot.find(params[:id])
    if @slot.users << current_user
      UserMailer.user_slot_sign_up(current_user,@slot).deliver
      flash[:success] = "Added to Muti-rider session for #{@slot.date} at #{@slot.start_time}"
    else
      flash[:waring] = "There was an issue adding you to the Muti-rider session"
    end
  end

  def remove_user_from_slot
    @slot = Slot.find(params[:id])
    if @slot.users.delete(current_user)
      flash[:notice] = "You have been removed from this session"
    end
  end

  def signed_up?
    @slot = Slot.find(params[:id])
    @slot.users.where(:id => current_user.id).present?
  end

end
