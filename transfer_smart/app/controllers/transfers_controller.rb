class TransfersController < ApplicationController
	include SessionsHelper
	require "securerandom"

	def create
		#transfer = Transfer.new()
		#transfer.user_id = current_user.id

		#if(transfer.save)
		#	redirect_to 

	end

	def edit
		@transfer = Transfer.find(session[:transfer_id])
		@user = current_user
		@exchange_info = ExchangeInfo.find(@transfer.exchange_info_id)
		@amount = @exchange_info.sending_ammount.to_s+"\t"+@exchange_info.currency_from
		@description = (SecureRandom.hex(8)).upcase

	end

	private

		def transfer_params

		end
end
