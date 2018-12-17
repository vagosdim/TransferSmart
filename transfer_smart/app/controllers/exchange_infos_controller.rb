class ExchangeInfosController < ApplicationController

	def new
		@exchange_info = ExchangeInfo.new
	end

	def create
  	@exchange_info = User.new(exchange_info_params)
  	if @exchange_info.save
        session[:exchange_info_id] = @exchange_info.id
  		#flash[:success] = "Welcome to TransferSmart"
  		redirect_to @user
  	    #handle successful signuo
  	else
    	render 'new'
    end
  end

  private

  	def exchange_info_params
    	params.require(:exchange_info).permit(:sending_ammount, :receiving_ammount, :currency_from, :currency_to, :exchange_rate)
    end
end
