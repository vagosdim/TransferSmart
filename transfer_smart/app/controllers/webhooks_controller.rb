class WebhooksController < ApplicationController
include WebhooksHelper
protect_from_forgery :except => [:receive]

    def receive
  	  puts("RECEIVING DATA!\n\n")
  	  data = params.as_json
  	  puts data
  	  puts data["resourceId"]
  	
#      if request.headers["Content-Type"].include?("application/json")
 #       if request.headers["X-Fineract-Endpoint"].include?("mifos.com")
  #        	puts "Received webhook from TransferSmart-US."
   #		    	if request.headers["X-Fineract-Entity"] == "ACCOUNTTRANSFER"
   	#	      		puts "It is an ACCOUNTTRANSFER"
   				      find_corresponding_transfer_in_bank(data, request.headers["X-Fineract-Endpoint"])
   	#	     	end
   	#	  end
 #  	  end
    end


    def receive_2


    end
    
end
