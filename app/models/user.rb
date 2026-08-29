class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :images, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validate :unique_email
  def unique_email
      if User.find_by(email_address: email_address)
        errors.add(:email_address, "already exists.")
        # TODO: validate binary mathes mimetype
      end
  end
end
