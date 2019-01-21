class RecipientInfosController < ApplicationController
	
  require "securerandom"

	def new
		@recipient_info = RecipientInfo.new
	end

	
	def create
		@recipient_info = RecipientInfo.new(recipient_params)
    @recipient_info.transfer_id = session[:transfer_id]
    if @recipient_info.save
     	@transfer = Transfer.find(session[:transfer_id])
      @transfer.recipient_info_id = @recipient_info.id
      create_unique_reference(@transfer)
      @transfer.save
  	  redirect_to '/transfer_summary', id: @transfer.id
   	else
      render 'new'
    end
	end

	private

	
  def recipient_params
    	params.require(:recipient_info).permit(:name, :email, :iban, :bank_code, :description)
  end

  def create_unique_reference(transfer)
    ref = (SecureRandom.hex(8)).upcase
    t = Transfer.find_by(reference: ref)
    while t
      ref = (SecureRandom.hex(8)).upcase
      t = Transfer.find_by(reference: ref)
    end
    transfer.reference = ref
  end

end
