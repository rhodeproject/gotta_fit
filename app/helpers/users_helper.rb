module UsersHelper

  def slot_count(user)
    slots = user.slots.count
  end

  def is_admin(user)
    if user.admin?
      "yes"
    else
      "no"
    end
  end

  def ride_count(user)
    count = 0
    count = user.purchased_rides unless user.purchased_rides.nil?
    count
  end
end

