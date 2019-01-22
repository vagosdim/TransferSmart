class PersonalInfosController < ApplicationController
  include SessionsHelper

	def new
		@personal_info = ""
    if(current_user.transfers.count > 1)
      @personal_info = PersonalInfo.find(current_user.transfers.second_to_last.personal_info_id)
    else
      @personal_info = PersonalInfo.new
    end
	end

	def create
		@personal_info = PersonalInfo.new(personal_info_params)
    @personal_info.transfer_id = session[:transfer_id]
  	if @personal_info.save
      next_step  
    else
    	render 'new'
    end

	end

  def update
    @personal_info = PersonalInfo.find(params[:id])
    if @personal_info.update_attributes(personal_info_params)
      next_step
    else
      render 'new'
    end
  end

	private

	def personal_info_params
    	params.require(:personal_info).permit(:first_name, :last_name, :email, :country, :city, :address, :postal_code)
  end

  def next_step
    @transfer = Transfer.find(session[:transfer_id])
    @transfer.personal_info_id = @personal_info.id
    @transfer.save
    redirect_to '/recipient_info'
  end
end
