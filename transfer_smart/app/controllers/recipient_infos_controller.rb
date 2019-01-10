class RecipientInfosController < ApplicationController
	
	def new
		@recipient = RecipientInfo.new
	end

	
	def create
		@recipient = RecipientInfo.new#(recipient_params)
    @recipient.transfer_id = session[:transfer_id]
    if @recipient.save
      session[:recipient_id] = @recipient.id
     	@transfer = Transfer.find(session[:transfer_id])
      @transfer.recipient_info_id = @recipient.id
  		#flash[:success] = "Welcome to TransferSmart"
  	  redirect_to '/transfer_summary'
  	    #handle successful signuo
   	else
      render 'new'
    end
	end

	private

	
  #def recipient_params
   # 	params.require(:recipient).permit(:name, :email, :iban, :bank_code, :description)
  #end
end
