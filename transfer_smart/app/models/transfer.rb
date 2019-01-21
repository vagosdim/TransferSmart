class Transfer < ApplicationRecord
  scope :initiated, -> {where(status: 'Initiated')}
	belongs_to :user
	has_one :exchange_info, :dependent => :destroy
	has_one :personal_info, :dependent => :destroy
	has_one :recipient_info, :dependent => :destroy


	def receipt
    exchange_info = ExchangeInfo.find(exchange_info_id)
    amount_sent = exchange_info.sending_ammount
    recipient = RecipientInfo.find(recipient_info_id)
    Receipts::Receipt.new(
      id: id,
      subheading: "RECEIPT FOR TRANSFER #%{id}",
      product: "TransferSmart",
      company: {
        name: "TransferSmart, Inc.",
        address: "University of Ioannina\nFloor 1\nIoannina Greece",
        email: "transfersmart.developer@gmail.com",
        logo: Rails.root.join("app/assets/images/rails-logo.jpeg")
      },
      line_items: [
        ["Sender", "#{user.name} (#{user.email})"],
        ["Recipient",        "#{recipient.name}"],
        ["IBAN",         "#{recipient.iban}"],
        ["Amount",     "#{amount_sent} #{exchange_info.currency_from}"],
        ["Transfer Reference", "#{reference}"],
        ["Date",           created_at.to_s]
      ]
    )
  end

end
