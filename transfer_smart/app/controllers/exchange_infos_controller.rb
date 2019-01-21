class ExchangeInfosController < ApplicationController
  def filled?
    puts @exchange_info.sending_ammount
  end
  helper_method :filled?

	def new
    transfer = Transfer.new
    if(!session[:transfer_id])
      my_id = session[:user_id]
      transfer.user_id =  my_id
      if transfer.save
        session[:transfer_id] = transfer.id
      end
    else
      @transfer = Transfer.find(session[:transfer_id])
    end  
		@exchange_info = ExchangeInfo.new
	end

	def create
  	@exchange_info = ExchangeInfo.new(exchange_info_params)
    @exchange_info.transfer_id = session[:transfer_id]
  	if @exchange_info.save
        @transfer = Transfer.find(session[:transfer_id])
        @transfer.exchange_info_id = @exchange_info.id
        @transfer.save
  		redirect_to '/personal_info'
  	else
    	render 'new'
    end
  end

  private

  	def exchange_info_params
    	params.require(:exchange_info).permit(:sending_ammount, :receiving_ammount, :currency_from, :currency_to, :exchange_rate)
    end
end
