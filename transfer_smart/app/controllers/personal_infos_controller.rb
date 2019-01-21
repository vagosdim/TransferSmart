class PersonalInfosController < ApplicationController

	def new
		@personal_info = PersonalInfo.new
		
	end

	def create
		@personal_info = PersonalInfo.new(personal_info_params)
    @personal_info.transfer_id = session[:transfer_id]
  	if @personal_info.save
      @transfer = Transfer.find(session[:transfer_id])
      @transfer.personal_info_id = @personal_info.id
      @transfer.save
  		redirect_to '/recipient_info'
    else
    	render 'new'
    end

	end

	private

	def personal_info_params
    	params.require(:personal_info).permit(:first_name, :last_name, :email, :country, :city, :address, :postal_code)
  end
end
