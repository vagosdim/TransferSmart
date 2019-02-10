class TransfersController < ApplicationController
	include SessionsHelper
	include WebhooksHelper

	#before_action :logged_in_user, only: [:edit, :show]

	def index
		user = current_user
		@transfers = user.transfers.order(created_at: :desc)
	end

	def destroy
		@transfer = Transfer.find(params[:id])
		@transfer.destroy
		session.delete(:transfer_id)
		redirect_to '/my_transfers'

	end


	def edit
		@transfer = ""
		if(params[:id])
			@transfer = Transfer.find(params[:id])
		else
			@transfer = Transfer.find(session[:transfer_id])
		end
		session.delete(:transfer_id)
		@transfer.status = "Pending"
		@transfer.save
		@user = current_user
		@exchange_info = ExchangeInfo.find(@transfer.exchange_info_id)
		@recipient = RecipientInfo.find(@transfer.recipient_info_id)
		@recipient_name = @recipient.name
		sender = PersonalInfo.find(@transfer.personal_info_id)
		@sender = sender.first_name + " " + sender.last_name

		@account = @exchange_info.currency_from[0, @exchange_info.currency_from.length - 1] +
		            "-01-" + get_transfersmart_account_no(@recipient.bank_code)
		@amount = @exchange_info.sending_ammount.to_s+"\t"+@exchange_info.currency_from
		@description = @transfer.reference

	end


	def update
		@transfer = Transfer.find(params[:id])
		if @transfer.update_attributes(status: "Initiated")		
			redirect_to '/my_transfers'
			HardWorker.perform_async(@transfer.id)
		else
			render 'edit'
		end
	end

	def show
		@transfer = Transfer.find(params[:id])
		respond_to do |format|
			format.pdf { 
				send_data(@transfer.receipt.render, 
				filename: "transfer-#{@transfer.id}-receipt.pdf",
				type: "application/pdf", 
			    disposition: :inline)
		    }
		end

	end

	private

		def get_transfersmart_account_no(bank_code)
			server = "https://10.0.3.COUNTRY:443/fineract-provider/api/v1/"
			url = "https://10.0.3.COUNTRY:443/fineract-provider/api/v1/clients?displayName=TransferSmart"
			if(bank_code == "MFBNUSNY")
				url.sub!("COUNTRY", "149")
				server.sub!("COUNTRY", "149")
			elsif(bank_code == "MFBNEUAA")
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
