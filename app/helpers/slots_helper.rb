module SlotsHelper

  def showday(sdate)
    Date.strptime(sdate, '%Y-%m-%d' ).strftime('%A %m/%d/%Y')
  end

  def showtime(stime)
    Time.strptime(stime, '%H:%M').strftime('%l:%M %p')
  end

  def signed_up?
    @slot = Slot.find(params[:id])
    @slot.users.where(:id => current_user.id).present?
  end
end
