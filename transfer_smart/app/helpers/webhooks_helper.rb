module WebhooksHelper
	require 'net/http'
	require 'uri'
	require 'openssl'
	require 'json'

    def find_corresponding_transfer_in_bank(data, server)

		uri = URI.parse("https://10.0.3.148:443/fineract-provider/api/v1/accounttransfers/30")#+data["resourceId"].to_s)
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

		parsed_json = JSON.parse(response.body)
		pretty_json = JSON.pretty_generate(parsed_json)

		puts pretty_json
		puts"DEBUG"
		puts parsed_json["transferDescription"]
		accept_transfer(parsed_json["transferDescription"].to_s)

	end


	def accept_transfer(ref)
		transfer = Transfer.find_by(reference: ref)
		if(transfer)
		  #transfer.completed = true

		  find_recipient(transfer)
		end
	end

	def find_recipient(transfer)
		puts 'DEBUG\n\nSearching Recipient\n\n'
		recipient = RecipientInfo.find(transfer.recipient_info_id)
		recipient_name = (recipient.name).sub(" ","_")
		uri = URI.parse("https://10.0.3.233:8443/fineract-provider/api/v1/clients?displayName="+recipient_name+"&pretty=true")
		puts "https://10.0.3.233:8443/fineract-provider/api/v1/clients?"+recipient_name+"&pretty=true"
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

		# response.code
		#puts response.body
		parsed_json = JSON.parse(response.body)
		#parsed_json = JSON.pretty_generate(parsed_json)
		pretty_json = JSON.pretty_generate(parsed_json)
		#write all this in a loop to parse each client result!!!!!!!

		#puts parsed_json
		array = parsed_json["pageItems"]
		#puts array.length
		client = array[0]
	#	puts client
	puts pretty_json
		puts client["externalId"]
		puts client["id"]
		puts client["accountNo"]
		puts client["officeId"]
		transfer_funds_to_recipient(transfer)

	end

	def transfer_funds_to_recipient(transfer)

		todays_transferr_date = Date.today.strftime("%d")+" "+Date.today.strftime("%B")+" "+Date.today.strftime("%Y")

		uri = URI.parse("https://10.0.3.233:8443/fineract-provider/api/v1/accounttransfers")
		#uri = URI.parse("https://10.0.3.148:443/fineract-provider/api/v1/accounttransfers")
		request = Net::HTTP::Post.new(uri)
		request.content_type = "application/json"
		request["Fineract-Platform-Tenantid"] = "default"
		request["Authorization"] = "Basic bWlmb3M6cGFzc3dvcmQ="
		request.body = JSON.dump({
		  "fromOfficeId" => 1,
		  "fromClientId" => 3,
		  "fromAccountType" => 2,
		  "fromAccountId" => 9,
		  "toOfficeId" => 1,
		  "toClientId" => 2,
		  "toAccountType" => 2,
		  "toAccountId" => 1,
		  "dateFormat" => "dd MMMM yyyy",
		  "locale" => "en",
		  "transferDate" => todays_transferr_date,
		  "transferAmount" => "0.34",
		  "transferDescription" => "A description of the transfer"
		})

		req_options = {
		  use_ssl: uri.scheme == "https",
		  verify_mode: OpenSSL::SSL::VERIFY_NONE,
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		  http.request(request)
		end

		transfer.completed = true



	end



end
