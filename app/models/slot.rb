# == Schema Information
#
# Table name: slots
#
#  id         :integer         not null, primary key
#  date       :string(255)
#  start_time :string(255)
#  end_time   :string(255)
#  waiting    :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  spots      :integer
#
class Slot < ActiveRecord::Base
  attr_accessible :date, :end_time, :start_time, :waiting, :spots, :description
  has_many  :lists, dependent: :destroy
  has_many  :users, :through => :lists

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
  validates :spots, :presence => true
  validates :date, :uniqueness => {:scope => [:start_time, :end_time]}

  scope :by_week, lambda { |d| {:conditions =>  {:date => d.beginning_of_week..d.end_of_week}}}
  scope :by_month, lambda { |d| {:conditions => {:date => d.beginning_of_month..d.end_of_month}}}
  scope :by_day, lambda {|d| {:conditions => {:date => d}}}
  scope :by_next_week, lambda {|d| {:conditions => {:date => d.beginning_of_week.next_week..d.end_of_week.next_week}}}
  scope :by_next_month, lambda {|d| {:conditions => {:date => d.beginning_of_month.next_month..d.end_of_month.next_month}}}
  scope :by_tomorrow, lambda {|d| {:conditions => {:date => d.tomorrow}}}

  scope :before, lambda {|end_time| {:conditions => ["ends_time < ?", Slot.format_date(end_time)] }}
  scope :after, lambda {|start_time| {:conditions => ["starts_time > ?", Slot.format_date(start_time)] }}

  def remove_user(user)
    list = self.lists.where(:user_id => user.id)
    if list[0].state != "Waiting"
      check_wait_list(user)
    end
    if self.users.delete(user)
      user.add_ride
      message = "You have been removed from this session"
    end
    message
  end

  def add_user(user)
    if self.available_spots > 0
      state = "Signed Up"
    else
      state = "Waiting"
    end
    if self.users << user
      @list = user.lists.find_by_slot_id(self.id)
      @list.update_attribute('state', state)
      user.remove_ride unless state == "Waiting"
      UserMailer.user_slot_sign_up(user,self).deliver
      flash  = "You are #{state} for session!"
    else
      flash = "There was an issue adding you to the Multi-rider session"
    end
    flash
  end

  def available_spots
    slot_count = self.spots
    slots_taken = self.lists.where(:state => "Signed Up").count
    slot_count - slots_taken
  end

  def waiting
    self.lists.where(:state => "Waiting").count
  end

  private

  def check_wait_list(user)
    list = self.lists.where(:state => "Waiting").order('updated_at ASC')
    if list.count > 0
      list[0].update_attribute('state', 'Signed Up')
      user.remove_ride
      UserMailer.wait_list_notice(list[0].user, self).deliver
    end
    #UserMailer.user_slot_sign_up(user,self).deliver
  end

  def convertdate(sdate)
    #DateTime.parse(sdate)
    Date.strptime(sdate, '%m/%d/%Y').strftime('%Y-%m-%d')
  end

  def converttime(stime)
    (Time.parse stime).strftime('%H:%M:%S')
  end

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

end


