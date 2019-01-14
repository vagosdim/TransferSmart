class PersonalInfo < ApplicationRecord
	belongs_to :transfer

	validates :first_name, presence: true, length: {minimum: 2, maximum: 40}
	validates :last_name, presence: true, length: {minimum: 2, maximum: 40}

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
                    

    validates :country, presence: true
    validates :city, presence: true
    validates :address, presence: true
end
