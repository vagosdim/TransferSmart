class PersonalInfosController < ApplicationController

	def new
		@personal_info = PersonalInfo.new
		
	end

	def create
		@personal_info = PersonalInfo.new(personal_info_params)
    @personal_info.transfer_id = session[:transfer_id]
  	if @personal_info.save
      #session[:personal_info_id] = @personal_info.id
      @transfer = Transfer.find(session[:transfer_id])
      @transfer.personal_info_id = @personal_info.id
      @transfer.save
  		#flash[:success] = "Welcome to TransferSmart"
  		redirect_to '/recipient_info'
  	    #handle successful signuo
    else
    	render 'new'
    end

	end

	private

	def personal_info_params
    	params.require(:personal_info).permit(:first_name, :last_name, :email, :country, :city, :address, :postal_code)
  end
end
