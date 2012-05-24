class Slot < ActiveRecord::Base
  attr_accessible :date, :end_time, :start_time, :waiting, :spots
  has_and_belongs_to_many  :users

  before_save {|slot| slot.date = convertdate(date)}
  before_save {|slot| slot.start_time = converttime(start_time)}
  before_save {|slot| slot.end_time = converttime(end_time)}

  #constants
  VALID_DATE_REGEX = /\d{2}\/\d{2}\/\d{4}/
  VALID_TIME_REGEX = /\d{2}\:\d{2}/

  #validation
  validates :date, :presence => true
  validates :start_time, :presence =>  true
  validates :end_time, :presence => true
  validate :spots, :presence => true

  private

  def convertdate(sdate)
    #DateTime.parse(sdate)
    Date.strptime(sdate, '%m/%d/%Y').strftime('%m/%d/%Y')
  end

  def converttime(stime)
    (Time.parse stime).strftime('%I:%M %p')
  end
end
