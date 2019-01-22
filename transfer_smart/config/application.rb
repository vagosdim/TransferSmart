require_relative 'boot'

require 'rails/all'
require 'net/http'
require 'uri'
require 'openssl'
require 'json'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TransferSmart
  #include CurrencyHistoriesHelper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    if defined?(Rails::Server)
  		config.after_initialize do

  			interesting_currencies = ['SEK', 'BTC', 'GBP', 'JPY', 'AUD', 'CAD', 'CNY', 'CHF', 'EUR', 'HKD']
			yesterday = DateTime.now - 7.days
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
  end
end
