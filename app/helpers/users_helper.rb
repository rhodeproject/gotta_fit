module UsersHelper
  def slot_count(user)
    slots = user.slots.count
  end
end
