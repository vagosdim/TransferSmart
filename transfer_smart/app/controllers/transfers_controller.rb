class TransfersController < ApplicationController
	include SessionsHelper
	include WebhooksHelper

	#before_action :logged_in_user, only: [:edit, :show]

	def edit
		@transfer = Transfer.find(session[:transfer_id])
		@transfer.status = "Initiated"
		@transfer.save
		@user = current_user
		@exchange_info = ExchangeInfo.find(@transfer.exchange_info_id)
		@recipient = RecipientInfo.find(@transfer.recipient_info_id)
		@recipient_name = @recipient.name
		sender = PersonalInfo.find(@transfer.personal_info_id)
		@sender = sender.first_name + " " + sender.last_name

		@account = @exchange_info.currency_from[0, @exchange_info.currency_from.length - 1] +
		            "-01-" + get_transfersmart_account_no(@exchange_info.currency_from)
		@amount = @exchange_info.sending_ammount.to_s+"\t"+@exchange_info.currency_from
		@description = @transfer.reference

	end

	def show
		@transfer = Transfer.find(1)#params[:id])
		respond_to do |format|
			format.pdf { 
				send_data(@transfer.receipt.render, 
				filename: "#{@transfer.created_at.strftime("%Y-%m-%d")}-receipt.pdf",
				type: "application/pdf", 
			    disposition: :inline,
			    attachment: :inline)
		    }
		end

	end

	private

		def get_transfersmart_account_no(currency)
			server = "https://10.0.3.COUNTRY:443/fineract-provider/api/v1/"
			url = "https://10.0.3.COUNTRY:443/fineract-provider/api/v1/clients?displayName=TransferSmart"
			if(currency == "USD")
				url.sub!("COUNTRY", "148")
				server.sub!("COUNTRY", "148")
			elsif(currency == "EUR")
				url.sub!("COUNTRY", "233")
				server.sub!("COUNTRY", "233")
			end
			transfer_smart_client = get_transfer_smart_client(url)
			transfer_smart_account = get_transfer_smart_savings_account(server+"clients/"+
 			                                  transfer_smart_client["id"].to_s+
 			                                  "/accounts")

 			return transfer_smart_account["accountNo"].to_s
		end

		def logged_in_user
      		unless logged_in?
        	store_location
        	flash[:danger] = "Require login to edit."
        	redirect_to login_url
      end
    end
end
