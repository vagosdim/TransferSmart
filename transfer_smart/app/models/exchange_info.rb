class ExchangeInfo < ApplicationRecord
	belongs_to :transfer

	validates :currency_to, presence: true, length: {minimum: 2, maximum: 3}
	validates :currency_from, presence: true, length: {minimum: 2, maximum: 3}
	validates :sending_ammount, presence: true
	validates :receiving_ammount, presence: true
    
end
