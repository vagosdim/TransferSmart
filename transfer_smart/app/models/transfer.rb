class Transfer < ApplicationRecord
	belongs_to :user
	has_one :exchange_info
	has_one :personal_info
	has_one :recipient_info


	def receipt
    Receipts::Receipt.new(
      id: id,
      subheading: "RECEIPT FOR CHARGE #%{id}",
      product: "GoRails",
      company: {
        name: "One Month, Inc.",
        address: "37 Great Jones\nFloor 2\nNew York City, NY 10012",
        email: "teachers@onemonth.com",
        logo: Rails.root.join("app/assets/images/rails-logo.jpeg")
      },
      line_items: [
        ["Date",           created_at.to_s],
        ["Account Billed", "#{user.name} (#{user.email})"],
        ["Product",        "GoRails"]
        #["Amount",         "$#{amount / 100}.00"],
        #["Charged to",     "#{card_type} (**** **** **** #{card_last4})"],
        #["Transaction ID", uuid]
      ]#,
      #font: {
       # bold: Rails.root.join('app/assets/fonts/tradegothic/TradeGothic-Bold.ttf'),
        #normal: Rails.root.join('app/assets/fonts/tradegothic/TradeGothic.ttf'),
      #}
    )
  end

end
