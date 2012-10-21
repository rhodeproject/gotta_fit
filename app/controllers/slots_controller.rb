class SlotsController < ApplicationController
  def new
    @slot = Slot.new
  end

  def edit
    @user = User.find(params[:id])

  end

  def update
    #Add user to Slot/Session
    if params[:commit] == "Add Me" || params[:commit] == "Join Waiting List"
      if signed_up?
        flash[:warning] = "you are already signed up for this session"
        redirect_to @slot
      else
        @slot = Slot.find(params[:id])
        add_user_to_slot
        redirect_to @slot
      end
    end

    #Remove user from Slot/Session
    if params[:commit] == "Remove Me"
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

        respond_to do |format|
          format.html {
            flash[:success] = "New rider session created"
            redirect_to '/schedule/weekly'
          }
          format.json {render :json => @slots}
        end
      else
        respond_to do |format|
          format.html {
            flash[:error] = "There was an issue creating the session"
            redirect_to new_slot_path
          }
          format.json {render :json => @slots}
        end
      end
    else
      flash[:warning] = "You must be the site admin to add sessions"
    end
  end

  def destroy
  end

  def calendar
    @slots = Slot.all
    @slots = Slot.paginate(page: params[:page], :per_page => 7).order('date, start_time ASC').by_month Date.today

    respond_to do |format|
      format.html  { render :html => @slots}
      format.xml  { render :xml => @slots }
      format.js  { render :json => @slots }
    end
  end

  def index
    @slot = Slot.new
    if signed_in?
      #Detemine the View for Slots Monthly, Weekly, or Daily
      case params[:view]
        when "weekly"
          #@slots = Slot.paginate(page: params[:page], :per_page => 7).order('date, start_time ASC').by_week Date.today
          @slots = Slot.order('date, start_time ASC').by_week Date.today
        when "monthly"
          #@slots = Slot.paginate(page: params[:page], :per_page => 7).order('date, start_time ASC').by_month Date.today
          @slots = Slot.order('date, start_time ASC').by_month Date.today
        when "daily"
          #@slots = Slot.paginate(page: params[:page], :per_page => 7).order('start_time ASC').by_day Date.today
          @slots = Slot.order('start_time ASC').by_day Date.today
        when "next_week"
          #@slots = Slot.paginate(page: params[:page], :per_page => 7).order('start_time ASC').by_next_week Date.today
          @slots = Slot.order('start_time ASC').by_next_week Date.today
        when "next_month"
          #@slots = Slot.paginate(page: params[:page], :per_page => 7).order('start_time ASC').by_next_month Date.today
          @slots = Slot.order('start_time ASC').by_next_month Date.today
        when "tomorrow"
          #@slots = Slot.paginate(page: params[:page], :per_page => 7).order('start_time ASC').by_tomorrow Date.today
          @slots = Slot.order('start_time ASC').by_tomorrow Date.today
        else
          #@slots = Slot.paginate(page: params[:page], :per_page => 7).order('date, start_time ASC')
          @slots = Slot.all(:order => "date, start_time DESC")
          #@slots = Slot.order('date, start_time ASC').by_month Date.today
      end

      respond_to do |format|
        format.html  { render :html => @slots}
        format.xml  { render :xml => @slots }
        format.js  { render :json => @slots }
      end

    else
      flash[:warning] = "You must be signed in to view sessions"
      redirect_to root_path
    end
  end

  def show
    if signed_in?
      @slot = Slot.find(params[:id])
      @riders = @slot.users.order('created_at ASC')
      @signedup = @slot.lists.where(:state => 'Signed Up')
      @waiting = @slot.lists.where(:state => 'Waiting')
    else
      flash[:warning] = "You must be signed in to view this!"
      redirect_to root_path
    end
  end

  private

  def add_user_to_slot
    @slot = Slot.find(params[:id])
    if spots_available(params[:id]) > 0
      state = "Signed Up"
    else
      state = "Waiting"
    end
    if @slot.users << current_user
      @list = current_user.lists.find_by_slot_id(params[:id])
      @list.update_attribute('state', state)
      current_user.remove_ride unless state == "Waiting"
      UserMailer.user_slot_sign_up(current_user,@slot).deliver
      flash[:success] = "You are #{state} for session!"
    else
      flash[:warning] = "There was an issue adding you to the Multi-rider session"
    end
  end

  def remove_user_from_slot
    @slot = Slot.find(params[:id])
    list = @slot.lists.where(:user_id => current_user.id)
    if list[0].state != "Waiting"
      check_wait_list
    end
    if @slot.users.delete(current_user)
      current_user.add_ride
      flash[:notice] = "You have been removed from this session"
    end
  end

  def check_wait_list
    @list = @slot.lists.where(:state => "Waiting").order('updated_at ASC')
    if @list.count > 0
      @list[0].update_attribute('state', 'Signed Up')
      current_user.remove_ride
      UserMailer.wait_list_notice(@list[0].user, @slot).deliver
    end
    UserMailer.user_slot_sign_up(current_user,@slot).deliver
  end
end
