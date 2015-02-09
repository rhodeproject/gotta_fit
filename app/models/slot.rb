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
  has_many  :lists, :dependent => :destroy
  has_many  :users, :through => :lists

  before_create {|slot| slot.date = convertdate(date)}
  before_save {|slot| slot.start_time = converttime(start_time)}
  before_save {|slot| slot.end_time = converttime(end_time)}
  after_update :update_lists

  #constants
  VALID_DATE_REGEX = /\d{2}\/\d{2}\/\d{4}/
  VALID_TIME_REGEX = /\d{2}\:\d{2}/
  STATUS_WAITING = "Waiting"
  STATUS_SIGNED_UP = "Signed Up"


  #validation
  validates :date, :presence => true
  validates :start_time, :presence =>  true
  validates :end_time, :presence => true
  validates :spots, :presence => true
  validates :date, :uniqueness => {:scope => [:start_time, :end_time]}

  scope :by_week, lambda { |d| {:conditions =>  {:date => d.beginning_of_week..d.end_of_week}}}
  scope :by_month, lambda { |d| {:conditions => {:date => d.beginning_of_month..d.end_of_month}}}
  scope :by_day, lambda {|d| {:conditions => {:date => d}}}
  scope :by_next_week, lambda { |d| {:conditions =>  {:date => d.beginning_of_week.next_week..d.end_of_week.next_week}}}
  scope :by_next_month, lambda {|d| {:conditions => {:date => d.beginning_of_month.next_month..d.end_of_month.next_month}}}
  scope :by_tomorrow, lambda {|d| {:conditions => {:date => d.tomorrow}}}
  scope :by_year, lambda {|d| {:conditions => {:date => d.beginning_of_year..d.end_of_year}}}

  scope :before, lambda {|end_time| {:conditions => ["end_time < ?", Slot.format_date(end_time)] }}
  scope :after, lambda {|start_time| {:conditions => ["start_time > ?", Slot.format_date(start_time)] }}
  scope :before_date, lambda {|start_date| {:conditions => ["date > ?", start_date] }}
  scope :after_date, lambda {|end_date| {:conditions => ["date < ?", end_date] }}

  #scope :waiting_list, {:conditions => ["state = ? and slot_id = ?", "Waiting", self.id]}
  #scope :signed_up, {:conditions => ["state = ? and slot_id = ?", "Signed Up", self.id]}

  def to_param
    "#{id} #{description}".parameterize
  end

  def waiting_list
    List.where(:state => STATUS_WAITING).where(:slot_id => self.id).order('id ASC')
  end

  def signed_up
    List.where(:state => STATUS_SIGNED_UP).where(:slot_id => self.id).order('id ASC')
  end

  def remove_user(user)
    list = self.lists.where(:user_id => user.id)
    if list[0].state != STATUS_WAITING
      check_wait_list(user)
    end
    if self.users.delete(user)
      user.add_ride
      flash = "#{user.name} has been removed from this session"
    else
      flash = "There was a problem removing #{user.name} from this session"
    end
    flash
  end

  def add_user(user)
    if self.available_spots > 0
      state = STATUS_SIGNED_UP
    else
      state = STATUS_WAITING
    end
    if self.users << user
      @list = user.lists.find_by_slot_id(self.id)
      @list.update_attribute('state', state)
      user.remove_ride unless state == STATUS_WAITING
      UserMailer.user_slot_sign_up(user,self).deliver unless state == STATUS_WAITING
      flash  = "#{user.name} is #{state} for session!"
    else
      flash = "There was an issue adding you to the Multi-rider session"
    end
    flash
  end

  def available_spots
    slot_count = self.spots
    slots_taken = self.lists.where(:state => STATUS_SIGNED_UP).count
    slot_count - slots_taken
  end

  def waiting
    self.lists.where(:state => STATUS_WAITING).count
  end

  def signed_up?(user)
    self.users.where(:id => user.id).present?
  end

  private

  def check_wait_list(user)
    list = self.lists.where(:state => STATUS_WAITING).order('updated_at ASC')
    if list.count > 0
      list[0].update_attribute('state', STATUS_SIGNED_UP)
      list[0].user.remove_ride
      #user.remove_ride
      UserMailer.wait_list_notice(list[0].user, self).deliver
    end
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

  def update_lists
    #When a slot is edited, check to see if there are available slots
    # and users on the waiting list, if so add waiting to signed up

    #check if there are spots available and users waiting
    if self.available_spots > 0 && self.waiting > 0

      #loop through until spots available are 0 and waiting count is 0
      while self.available_spots > 0 && self.waiting > 0 do
        #create an array of lists where state is waiting for this slot
        #then pick the top one form the list
        list = self.lists.where(:state => STATUS_WAITING).order('id ASC')
        check_wait_list(list[0].user)
      end
    end
  end

end


