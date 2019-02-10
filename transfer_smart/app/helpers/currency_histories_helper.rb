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
		if(CurrencyHistory.count == 0 or CurrencyHistory.first.updated_at.strftime("%d") != (DateTime.now - 2.hours).strftime("%d"))
			CurrencyHistory.delete_all
			today = DateTime.now
			today = today.strftime("%Y-%d-%m")
			interesting_currencies = ['BTC','SEK', 'GBP', 'JPY', 'AUD', 'CAD', 'CNY', 'CHF', 'EUR', 'HKD']
			symbols = interesting_currencies.join(",")
			app_key = 'app_id=2c02b1d3c85e4c7d88fbe5dd983d0965'
			url = 'https://openexchangerates.org/api/latest.json?'+app_key+"&symbols="+symbols
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
			calculate_variance
		end
	end

	def calculate_variance
		interesting_currencies = ['SEK', 'BTC', 'GBP', 'JPY', 'AUD', 'CAD', 'CNY', 'CHF', 'EUR', 'HKD']
		yesterday = DateTime.now - 1.days
		yesterday = yesterday.strftime("%Y-%m-%d")
		
		api_key = 'app_id=2c02b1d3c85e4c7d88fbe5dd983d0965'
		uri = URI.parse('https://openexchangerates.org/api/historical/'+yesterday+'.json?'+api_key)
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

		interesting_currencies.each do |currency|
			tmp = parsed_json["rates"][currency]
			currency = CurrencyHistory.find_by(target_currency: currency)
			if(currency)
				currency.percent_change = ((currency.convertion_from_base - tmp)/100.0)
				currency.save
			end
		end

	end
end
