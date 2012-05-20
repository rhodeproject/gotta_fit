class SlotsController < ApplicationController
  def new
    @slots = Slot.new
  end

  def edit
  end

  def create
    if current_user.admin?
      @slots = Slot.new(params[:slot])
      if @slots.save
        flash[:success] = "New rider session created"
        redirect_to slots_path
      else
        flash[:error] = "#{@slots.error.full_message.to_sentence}"
        redirect_to root_path
      end
    else
      flash[:waring] = "You must be the sight admin to add sessions"
    end
  end

  def destroy
  end

  def index
    @slots = Slot.all
  end
end
