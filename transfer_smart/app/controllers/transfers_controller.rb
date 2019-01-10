class TransfersController < ApplicationController

	def create
		#transfer = Transfer.new()
		#transfer.user_id = current_user.id

		#if(transfer.save)
		#	redirect_to 

	end

	def edit
		@transfer = Transfer.find(session[:transfer_id])
	end

	private

		def transfer_params

		end
end
