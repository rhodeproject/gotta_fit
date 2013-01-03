# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#  active          :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  confirm_code    :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :admin, :email, :first_name, :last_name, :password, :password_confirmation
  has_secure_password

  has_many :lists, :dependent => :destroy
  has_many :slots, :through => :lists

  #constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #callbacks
  after_create :create_remember_token
  before_save { |user| user.email = email.downcase}
  after_create  { |user| send_confirm(user)}
  after_create :set_rides

  #validation
  validates :first_name, :presence => true, :length => {:maximum => 50} #first_name must exist and cannot exceed 50 characters
  validates :last_name, :presence => true, :length => {:maximum => 50} #last_name must exist and cannot exceed 50 characters
  validates :email, :presence => true,
            :format => {:with => VALID_EMAIL_REGEX},
            :uniqueness => {:case_sensative => false} #email must exist, match the Regex for validate form, and must be unique
  validates :password, :presence => true, :length => {:minimum => 6} #password must exist and be at least 6 characters
  validates :password_confirmation, :presence => true

  #scopes
  scope :by_last_name, {:order => "last_name ASC"}
  scope :by_first_name, {:order => "first_name ASC"}
  scope :signed_up_today, {:conditions => ["created_at between ? and ?", Date.today, Date.tomorrow]}

  def to_param
    "#{id} #{name}".parameterize
  end

  def send_password_reset
    self.update_attribute('reset_token', generate_token)
    self.update_attribute('password_reset_sent_at', Time.zone.now)
    UserMailer.password_reset(self).deliver
  end

  def remove_ride
    self.update_attribute('purchased_rides', self.purchased_rides - 1)
  end

  def add_ride
    self.update_attribute('purchased_rides', self.purchased_rides + 1)
  end

  def completed_rides
    self.slots.count(:conditions => ["date < ?", Date.today])
  end

  def upcoming_rides
    self.slots.count(:conditions => ["date >= ?", Date.today])
  end

  def get_slot_state(slot_id)
    list = self.lists.find_by_slot_id(slot_id)
    list.state
  end

  def reminder_sent?(slot_id)
    list = self.lists.find_by_slot_id(slot_id)
    list.reminder_sent
  end

  def update_reminder_sent(slot_id)
    list = self.lists.find_by_slot_id(slot_id)
    list.update_attribute('reminder_sent', true)
  end

  def rides
    self.slots.where("date >= ?", Date.today).limit(3).order("date, start_time ASC")
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  #private methods for the user model
  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def generate_token
    SecureRandom.urlsafe_base64
  end

  def set_rides
    self.update_attribute('purchased_rides','0')
  end

  def send_confirm(user)
    UserMailer.new_user_confirmation(user).deliver
  end
end

