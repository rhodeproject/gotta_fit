class User < ActiveRecord::Base
  attr_accessible :admin, :email, :first_name, :last_name, :password, :password_confirmation
  has_secure_password

  #constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #callbacks
  before_save :create_remember_token
  before_save { |user| user.email = email.downcase}
  after_save  { |user| send_confirm(user)}

  #validation
  validates :first_name, presence: true, length:{maximum: 50} #first_name must exist and cannot exceed 50 characters
  validates :last_name, presence: true, length:{maximum: 50} #last_name must exist and cannot exceed 50 characters
  validates :email, presence: true,
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensative: false} #email must exist, match the Regex for validate form, and must be unique
  validates :password, presence: true, length:{minimum: 6} #password must exist and be at least 6 characters
  validates :password_confirmation, presence: true

  #private methods for the user model
  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def send_confirm(user)
    UserMailer.new_user_confirmation(user).deliver
  end

end
