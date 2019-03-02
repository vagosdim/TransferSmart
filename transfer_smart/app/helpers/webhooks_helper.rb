module WebhooksHelper
	require 'net/http'
	require 'uri'
	require 'openssl'
	require 'json'

	include SessionsHelper
	include TransfersHelper

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
		ref = ref.delete(" ")
		if(ref.bytesize == 16)
			webhook = Webhook.new(savings: data["resourceId"].to_i,
								  endpoint: server_address,
								  reference: ref)
			webhook.save
		end		
	end

	def find_recipient(transfer, server_address)
		target_server = server_address.clone

		if(server_address.include?("10.0.3.149"))
			target_server.sub!("149", "233" )
		elsif (server_address.include?("10.0.3.233"))
			target_server.sub!("233", "149" )
		end

		recipient = RecipientInfo.find(transfer.recipient_info_id)
		recipient_name = (recipient.name).sub(" ","_")
		recipient_iban = recipient.iban.clone
		description = recipient.description
		iban_fields = recipient_iban.split("-")
		external_id = iban_fields[2]
		accountId = iban_fields[3]

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

		transfer_funds_to_recipient(transfer, target_server, target_client, accountId, description, recipient.email)

	end
end
