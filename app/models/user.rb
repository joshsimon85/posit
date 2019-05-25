class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes, as: :voteable

  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: { minimum: 5 }

  sluggable_column :username

  def two_factor_auth?
    !self.phone.blank?
  end

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator'
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6)) #random 6 digit number
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    account_sid = 'ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    auth_token = 'your_auth_token'
    client = Twilio::REST::Client.new(account_sid, auth_token)

    msg = "Please input the pin to continue login: #{self.pin}"
    message = client.messages.create( body: msg, from: '', to:  '')
  end
end
