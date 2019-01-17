module WebhooksHelper
	require 'net/http'
	require 'uri'
	require 'openssl'
	require 'json'
#https://10.0.3.148/fineract-provider/api/v1/    US
        #https://10.0.3.233/fineract-provider/api/v1/    EU

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
    	puts "\n\nCHECK TRANSFER IN SERVER"
    	puts url
        response = get_request(url)

		parsed_json = JSON.parse(response.body)
		pretty_json = JSON.pretty_generate(parsed_json)

		puts pretty_json
		puts"DEBUG"
		puts parsed_json["transferDescription"]

		ref = parsed_json["transferDescription"].to_s
		transfer = Transfer.find_by(reference: ref)
		if(transfer)
		  if(transfer.status == "Initiated")
		  	transfer.status = "Completed-Halfway"
		  	find_recipient(transfer, server_address)
		  else
		  	transfer.status = "Completed"
		  	t.save
		  end
		end
	end

	def find_recipient(transfer, server_address)
		target_server = server_address.clone
		if(server_address.include?("10.0.3.148"))
			target_server.sub!("148", "233" )
		elsif (server_address.include?("10.0.3.233"))
			target_server.sub!("233", "148" )
		end

		puts 'DEBUG\n\nSearching Recipient\n\n'
		recipient = RecipientInfo.find(transfer.recipient_info_id)
		recipient_name = (recipient.name).sub(" ","_")
		url = target_server+"clients?displayName="+recipient_name+"&pretty=true"
		response = get_request(url)
		parsed_json = JSON.parse(response.body)
		pretty_json = JSON.pretty_generate(parsed_json)
		#write all this in a loop to parse each client result!!!!!!!

		#puts parsed_json
		array = parsed_json["pageItems"]
		#puts array.length
		client = array[0]
	#	puts client
		puts pretty_json
		puts client["externalId"].class
		puts client["id"]
		puts client["accountNo"]
		puts client["officeId"]
		transfer_funds_to_recipient(transfer, target_server, client)

	end

	def transfer_funds_to_recipient(transfer, target_server, client)


#Need a GET  REQUEST FOR THE DETAILS OF TRANSFERSMART IN THE OTHER COUNTRY

		todays_transfer_date = Date.today.strftime("%d")+" "+Date.today.strftime("%B")+" "+Date.today.strftime("%Y")
		exchange = ExchangeInfo.find(transfer.exchange_info_id)
		amount = exchange.receiving_ammount.to_s
		#https://DomainName/api/v1/clients/{clientId}/accounts
		#account_details = get_request(target_server+"clients/"+client["id"].to_s+"/accounts")
		#account_details = JSON.parse(account_details)
		#savings_account = account_details["savingsAccounts"]

		uri = URI.parse(target_server+"accounttransfers")
		
		request = Net::HTTP::Post.new(uri)
		request.content_type = "application/json"
		request["Fineract-Platform-Tenantid"] = "default"
		request["Authorization"] = "Basic bWlmb3M6cGFzc3dvcmQ="
		request.body = JSON.dump({
		  "fromOfficeId" => 4,
		  "fromClientId" => 3,
		  "fromAccountType" => 2,
		  "fromAccountId" => 10,
		  "toOfficeId" => client["officeId"].to_i,
		  "toClientId" => client["id"].to_i,
		  "toAccountType" => 2,
		  "toAccountId" => 4,#client["accountNo"].to_i,
		  "dateFormat" => "dd MMMM yyyy",
		  "locale" => "en",
		  "transferDate" => todays_transfer_date,
		  "transferAmount" => "0.125",
		  "transferDescription" => "A description of the transfer"
		})

		req_options = {
		  use_ssl: uri.scheme == "https",
		  verify_mode: OpenSSL::SSL::VERIFY_NONE,
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		  http.request(request)
		end

		puts response

		transfer.status = "Completed"
	end
end
