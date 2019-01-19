module CurrencyHistoriesHelper
	require 'net/http'
	require 'uri'
	require 'openssl'
	require 'json'

	def init_currency_history(base)
		puts "SOMETHING"
		interesting_currencies = ['EUR', 'USD', 'GBP', 'JPY', 'AUD', 'CAD', 'CNY', 'CHF', 'SGD', 'HKD']
		symbols = interesting_currencies.join(",")
		if(CurrencyHistory.all.count == 0)

			uri = URI.parse('https://api.exchangeratesapi.io/latest?base='+base+"&symbols="+symbols)
			request = Net::HTTP::Get.new(uri)
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

			parsed_json["rates"].each do |key, value|
				currency_history = CurrencyHistory.new(
					base: base, target_currency: key,
					convertion_from_base: value.round(6),
					convertion_to_base: (1./value).round(6),
					percent_change: 0.0 )
				currency_history.save
			end
		end
	end
end
