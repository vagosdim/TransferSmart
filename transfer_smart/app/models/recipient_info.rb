class RecipientInfo < ApplicationRecord
	belongs_to :transfer

	#validates :name, presence: true, length: {minimum: 2, maximum: 40}
	#VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    #validates :email, presence: true, length: { maximum: 255 },
    #                format: { with: VALID_EMAIL_REGEX }

	#validates :iban, presence: true
	#validates :bank_code, presence: true
	#validates :description, presence: true                 
end
