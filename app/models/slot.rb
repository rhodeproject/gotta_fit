class Slot < ActiveRecord::Base
  attr_accessible :date, :end_time, :start_time, :waiting, :spots
  has_and_belongs_to_many  :users

  #constants
  VALID_DATE_REGEX = /\d{2}\/\d{2}\/\d{4}/
  VALID_TIME_REGEX = /\d{2}\:\d{2}/

  #validation
  validates :date, :presence => true
  validates :start_time, :presence =>  true
  validates :end_time, :presence => true
  validate :spots, :presence => true


end
