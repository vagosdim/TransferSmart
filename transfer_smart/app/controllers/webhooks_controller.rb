class WebhooksController < ApplicationController
include WebhooksHelper
protect_from_forgery :except => [:receive]

    def receive
  	  puts("RECEIVING DATA!\n\n")
  	  data = params.as_json
  	  puts data
  	  puts data["resourceId"]
  	
      if request.headers["Content-Type"].include?("application/json")
        if request.headers["X-Fineract-Endpoint"].include?("10.0.3.148")
          	puts "Received webhook from TransferSmart-US."
   		    	
        elsif request.headers["X-Fineract-Endpoint"].include?("10.0.3.233")
            puts "Received webhook from TransferSmart-EU."
   		  end
        puts request.headers["X-Fineract-Endpoint"]
        #https://10.0.3.148/fineract-provider/api/v1/    US
        #https://10.0.3.233/fineract-provider/api/v1/    EU

        if request.headers["X-Fineract-Entity"] == "ACCOUNTTRANSFER"
            puts "It is an ACCOUNTTRANSFER"
            check_transfer_in_server(data, request.headers["X-Fineract-Endpoint"])
        end
   	  end
    end
    
end
