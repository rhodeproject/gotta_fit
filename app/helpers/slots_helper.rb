module SlotsHelper

  def spots_available(id)
    slot = Slot.find(id)
    slot_count = slot.spots
    slots_taken = slot.users.count
    slot_count - slots_taken
  end

  def showday(sdate)
    Date.strptime(sdate, '%Y-%m-%d' ).strftime('%A %m/%d/%Y')
  end

  def signed_up?
    @slot = Slot.find(params[:id])
    @slot.users.where(:id => current_user.id).present?
  end

end
