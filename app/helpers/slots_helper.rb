module SlotsHelper

  def spots_available(id)
    slot = Slot.find(id)
    slot_count = slot.spots
    slots_taken = slot.users.count
    slot_count - slots_taken
  end

  def showday(sdate)
    Date.strptime(sdate, '%m/%d/%Y' ).strftime('%A %m/%d/%Y')
  end

end
