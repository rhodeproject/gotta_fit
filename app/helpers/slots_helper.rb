module SlotsHelper
  def slotdate(sdate)
    DateTime.parse(sdate)
  end

  def spots_available(id)
    slot = Slot.find(id)
    slot_count = slot.spots
    slots_taken = slot.users.count
    slot_count - slots_taken
  end
end
