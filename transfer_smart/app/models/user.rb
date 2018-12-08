class User < ApplicationRecord
	has_secure_password
	before_save {self.email = email.downcase}
	validates :name, presence: true, length: {minimum: 2, maximum: 40}
	  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false}
    validates :password, presence: true, length: { minimum: 8}

end
