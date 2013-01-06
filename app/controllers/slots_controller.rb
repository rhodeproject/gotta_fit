class SlotsController < ApplicationController
  before_filter :admin_check, :only => [:create, :update, :destroy]
  before_filter :sign_in_check

  def new
    @slot = Slot.new
  end

  def edit
    @slot = Slot.find(params[:id])
  end

  def update
    @slot = Slot.find(params[:id])
    if params[:commit] == "Add Me" || params[:commit] == "Join Waiting List" #user adds themselves
      if signed_up?
        flash[:warning] = "you are already signed up for this session"
      else
        flash[:success] = @slot.add_user(current_user)
      end
    elsif params[:commit] == "add/remove rider" #admin adds/removes another user
      user = User.find(params[:all][:users])
      if @slot.signed_up?(user)
        flash[:success] = @slot.remove_user(user)
      else
        flash[:success] = @slot.add_user(user)
      end
    elsif params[:commit] == "Remove Me" #remove user
      if signed_up?
        flash[:success] =  @slot.remove_user(current_user)
      else
        flash[:notice] = "You are not signed up"
      end
    else
      #update the slot data
      @slot.update_attributes(:description => params[:slot][:description],
                              :start_time => params[:slot][:start_time],
                              :end_time => params[:slot][:end_time],
                              :spots => params[:slot][:spots])
      flash[:success] = "update successful"
    end
    redirect_to @slot
  end

  def create
    @slot = Slot.new(params[:slot])
    if @slot.save
      respond_to do |format|
        format.html {
          flash[:success] = "New rider session created"
          redirect_to '/schedule/weekly'
        }
        format.json {render :json => @slot}
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "There was an issue creating the session"
          redirect_to new_slot_path
        }
        format.js {render :json => @slot}
      end
    end
  end

  def destroy
    @remove = Slot.find(params[:id])
    @remove.destroy
    flash[:warning] = "Rider Session removed"
    redirect_to '/schedule/weekly'
  end

  def calendar
    @slots = Slot.all
    @slots = Slot.paginate(:page =>  params[:page], :per_page => 7).order('date, start_time ASC').by_month Date.today

    respond_to do |format|
      format.html  { render :html => @slots}
      format.xml  { render :xml => @slots }
      format.js  { render :json => @slots }
    end
  end

  def index
    @slot = Slot.new

    #Detemine the View for Slots Monthly, Weekly, or Daily
    case params[:view]
      when "weekly"
        @slots = Slot.order('date, start_time ASC').by_week Date.today
      when "monthly"
        @slots = Slot.order('date, start_time ASC').by_month Date.today
      when "daily"
        @slots = Slot.order('date, start_time ASC').by_day Date.today
      when "next_week"
        @slots = Slot.order('date, start_time ASC').by_week(Date.today + 7.days)
      when "next_month"
        @slots = Slot.order('date, start_time ASC').by_next_month Date.today
      when "tomorrow"
        @slots = Slot.order('date, start_time ASC').by_tomorrow Date.today
      else
        @slots = Slot.all(:order => "date, start_time DESC")
    end

    respond_to do |format|
      format.html  { render :html => @slots}
      format.xml  { render :xml => @slots }
      format.js  { render :json => @slots }
    end

  end

  def show
    @slot = Slot.find(params[:id])
    @riders = @slot.signed_up.includes(:user)
    @waiting = @slot.waiting_list.includes(:user)
  end

private

  def admin_check
    unless current_user.admin?
      flash[:warning] = "you are not able to perform this action"
      redirect_to slots_path
    end
  end

  def sign_in_check
    unless signed_in?
      flash[:warning] = "please sign in"
      redirect_to root_path
    end
  end

end
