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

end

