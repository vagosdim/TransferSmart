class WebhooksController < ApplicationController
    include WebhooksHelper
    protect_from_forgery :except => [:receive]

    def receive
  	  data = params.as_json
      if request.headers["Content-Type"].include?("application/json")
        if request.headers["X-Fineract-Endpoint"].include?("10.0.3.148")
          	puts "Received webhook from TransferSmart-US."
   		    	
        elsif request.headers["X-Fineract-Endpoint"].include?("10.0.3.233")
            puts "Received webhook from TransferSmart-EU."
   		  end
        
        if request.headers["X-Fineract-Entity"] == "ACCOUNTTRANSFER"
            check_transfer_in_server(data, request.headers["X-Fineract-Endpoint"])
        end
   	  end
    end
    
end
