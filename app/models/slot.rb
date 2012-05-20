class Slot < ActiveRecord::Base
  attr_accessible :date, :end_time, :start_time, :waiting

  #validation
  validates :date, :presence => true
  validates :start_time, :presence =>  true
  validates :end_time, :presence => true,
                       :uniqueness => {:scope => :date}


end
