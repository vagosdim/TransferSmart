module TransfersHelper
	require 'net/http'
	require 'uri'
	require 'openssl'
	require 'json'

	include SessionsHelper
	

	def get_transfer_smart_client(url)
		transfer_smart_clients = get_request(url)
		transfer_smart_clients = JSON.parse(transfer_smart_clients.body)
		page_results = transfer_smart_clients["pageItems"]
		transfer_smart_client = ""
		page_results.select {|client|
 			if client["displayName"] == "TransferSmart"
   				transfer_smart_client = client 
 			end
 		}

 		return transfer_smart_client
	end

	def get_transfer_smart_savings_account(url)
		transfer_smart_accounts = get_request(url)
 		transfer_smart_accounts = JSON.parse(transfer_smart_accounts.body)
		transfer_smart_savings_account = transfer_smart_accounts["savingsAccounts"].first

		return transfer_smart_savings_account
	end


	def transfer_funds_to_recipient(transfer, target_server, client, accountId, description, recipient_email)
		account_type = 2
		todays_transfer_date = Date.today.strftime("%d")+" "+Date.today.strftime("%B")+" "+Date.today.strftime("%Y")
		exchange = ExchangeInfo.find(transfer.exchange_info_id)
		amount = exchange.receiving_amount.to_s
		transfer_smart_client = get_transfer_smart_client(target_server+"clients?displayName=TransferSmart&pretty=true") 

		transfer_smart_savings_account = get_transfer_smart_savings_account(target_server+"clients/"+
 			                                  transfer_smart_client["id"].to_s+
 			                                  "/accounts")
			

		uri = URI.parse(target_server+"accounttransfers")

		request = Net::HTTP::Post.new(uri)
		request.content_type = "application/json"
		request["Fineract-Platform-Tenantid"] = "default"
		request["Authorization"] = "Basic bWlmb3M6cGFzc3dvcmQ="
		request.body = JSON.dump({
		  "fromOfficeId" => transfer_smart_client["officeId"].to_i,
		  "fromClientId" => transfer_smart_client["id"].to_i,
		  "fromAccountType" => account_type,
		  "fromAccountId" => transfer_smart_savings_account["id"].to_i,
		  "toOfficeId" => client["officeId"].to_i,
		  "toClientId" => client["id"].to_i,
		  "toAccountType" => account_type,
		  "toAccountId" => accountId.to_i,
		  "dateFormat" => "dd MMMM yyyy",
		  "locale" => "en",
		  "transferDate" => todays_transfer_date,
		  "transferAmount" => amount,
		  "transferDescription" => description + "\t TransferSmart, Inc"
		})

		req_options = {
		  use_ssl: uri.scheme == "https",
		  verify_mode: OpenSSL::SSL::VERIFY_NONE,
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		  http.request(request)
		end
		if (response.kind_of? Net::HTTPSuccess)
			transfer.status = "Completed"
			transfer.save
			webhook = Webhook.find_by(reference: transfer.reference)
			Webhook.delete(webhook)
		end
		#ReceiptWorker.perform_async(transfer.id, sender_email, recipient_email)
	end
end