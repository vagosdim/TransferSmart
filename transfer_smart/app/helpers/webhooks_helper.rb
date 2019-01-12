module WebhooksHelper

    def find_corresponding_transfer(data, server)

		require 'net/http'
		require 'uri'
		require 'openssl'
		require 'json'

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
		parsed_json = JSON.pretty_generate(parsed_json)

		puts parsed_json

	end
end
