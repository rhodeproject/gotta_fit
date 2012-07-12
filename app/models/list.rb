class List < ActiveRecord::Base
  attr_accessible :slot_id, :user_id
  belongs_to  :user
  belongs_to  :slot

  def self.get_state(state)
    where("state = ?", state)
  end

  #scopes
  scope :waiting, get_state("Waiting")
  scope :confirmed, get_state("Confirmed")

end
