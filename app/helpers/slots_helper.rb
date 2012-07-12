module SlotsHelper

  def spots_available(id)
    slot = Slot.find(id)
    slot_count = slot.spots
    slots_taken = slot.lists.where(:state => "Signed Up").count
    slot_count - slots_taken
  end

  def waiting_list_count(id)
    slot = Slot.find(id)
    slot.lists.where(:state => "Waiting").count
  end

  def get_slot_state(user)
    list = user.lists.find_by_slot_id(params[:id])
    list.state
  end

  def showday(sdate)
    Date.strptime(sdate, '%Y-%m-%d' ).strftime('%A %m/%d/%Y')
  end

  def showtime(stime)
    Time.strptime(stime, '%H:%M').strftime('%l:%M %p')
  end

  def rides_completed(user)
    user.slots.count(:conditions => ["date < ?", Date.today])
  end

  def rides_upcoming(user)
    user.slots.count(:conditions => ["date >= ?", Date.today])
  end

  def user_rides(user)
    user.slots(:conditions => ['date >= ? ', Date.today]).order('date, start_time ASC')
  end

  def signed_up?
    @slot = Slot.find(params[:id])
    @slot.users.where(:id => current_user.id).present?
  end

end
