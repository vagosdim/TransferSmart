module WebhooksHelper
	require 'net/http'
	require 'uri'
	require 'openssl'
	require 'json'



    def get_request(url)
		uri = URI.parse(url)
		request = Net::HTTP::Get.new(uri)
		request["Fineract-Platform-Tenantid"] = "default"
		request["Authorization"] = "Basic bWlmb3M6cGFzc3dvcmQ="

		req_options = {
		  use_ssl: uri.scheme == "https",
		  verify_mode: OpenSSL::SSL::VERIFY_NONE,
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		  http.request(request)
		end

		return response

    end

    def check_transfer_in_server(data, server_address)
    	server_address.sub("/fineract", ":443/fineract")
    	url = server_address+"accounttransfers/"+data["resourceId"].to_s
        response = get_request(url)

		parsed_json = JSON.parse(response.body)
		pretty_json = JSON.pretty_generate(parsed_json)

		ref = parsed_json["transferDescription"].to_s
		if(ref.bytesize == 16)
			webhook = Webhook.new(savings: data["resourceId"].to_i,
								  endpoint: server_address,
								  reference: ref)
			webhook.save
		end		
	end

	def find_recipient(transfer, server_address)
		target_server = server_address.clone

		if(server_address.include?("10.0.3.148"))
			target_server.sub!("148", "233" )
		elsif (server_address.include?("10.0.3.233"))
			target_server.sub!("233", "148" )
		end

		recipient = RecipientInfo.find(transfer.recipient_info_id)
		recipient_name = (recipient.name).sub(" ","_")
		recipient_iban = recipient.iban.clone
		description = recipient.description
		iban_fields = recipient_iban.split("-")
		accountId = iban_fields[2]
		external_id = iban_fields[0]

		url = target_server+"clients?displayName="+recipient_name+"&pretty=true"
		response = get_request(url)
		parsed_json = JSON.parse(response.body)
		page_results = parsed_json["pageItems"]
		target_client = ""
		page_results.select{ |client|
			if client["externalId"] == external_id
				target_client = client
			end
		}
		puts target_client

		transfer_funds_to_recipient(transfer, target_server, target_client, accountId, description)

	end

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


	def transfer_funds_to_recipient(transfer, target_server, client, accountId, description)

		todays_transfer_date = Date.today.strftime("%d")+" "+Date.today.strftime("%B")+" "+Date.today.strftime("%Y")
		exchange = ExchangeInfo.find(transfer.exchange_info_id)
		amount = exchange.receiving_ammount.to_s
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
		  "fromAccountType" => 2,
		  "fromAccountId" => transfer_smart_savings_account["id"].to_i,
		  "toOfficeId" => client["officeId"].to_i,
		  "toClientId" => client["id"].to_i,
		  "toAccountType" => 2,
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

		puts "DEBUG\n\n\n\n\n\n\n\n"
		puts response.body

		#Check if response is ok

		transfer.status = "Completed"
		transfer.save

		#Delete thw Webhook item in db
		#Send mail with receipt attached
		#UserMailer.send(transfer.id)

	end

end
