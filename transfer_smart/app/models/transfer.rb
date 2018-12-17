class Transfer < ApplicationRecord
	belongs_to :user
	has_one :exchange_info
	has_one :personal_info
	has_one :recipient_info
end
