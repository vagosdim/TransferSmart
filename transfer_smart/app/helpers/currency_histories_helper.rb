module CurrencyHistoriesHelper
	require 'net/http'
	require 'uri'
	require 'openssl'
	require 'json'

	def get_currencies(url)

		uri = URI.parse(url)
		request = Net::HTTP::Get.new(uri)
		req_options = {
			use_ssl: uri.scheme == "https",
			verify_mode: OpenSSL::SSL::VERIFY_NONE,
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
			http.request(request)
		end

		parsed_json = JSON.parse(response.body)

		return parsed_json
	end

	def init_currency_history(base)
		today = DateTime.now
		today = today.strftime("%Y-%d-%m")
		interesting_currencies = ['USD','SEK', 'GBP', 'JPY', 'AUD', 'CAD', 'CNY', 'CHF', 'SGD', 'HKD']
		symbols = interesting_currencies.join(",")
		if(CurrencyHistory.all.count == 0)
			url = 'https://api.exchangeratesapi.io/latest?base='+base+"&symbols="+symbols
			parsed_json = get_currencies(url)
			puts url
			parsed_json["rates"].each do |key, value|
				currency_history = CurrencyHistory.new(
					base: base, target_currency: key,
					convertion_from_base: value,
					convertion_to_base: (1./value),
					percent_change: 0.0 )
				currency_history.save
			end
		end
	end
end
