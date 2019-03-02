class ExchangeInfo < ApplicationRecord
	belongs_to :transfer

	validates :currency_to, presence: true, length: {minimum: 2, maximum: 3}
	validates :currency_from, presence: true, length: {minimum: 2, maximum: 3}
	validates :sending_amount, presence: true
	validates :receiving_amount, presence: true
    
end
