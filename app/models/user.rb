class User < ActiveRecord::Base
  before_save { email.downcase! }
  attr_accessible :email, :name
  validates :name, presence: true, length: { maximum: 50, minimum: 3 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  has_secure_password
end
