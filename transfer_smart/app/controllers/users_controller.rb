class UsersController < ApplicationController
  #Editing allowed only if logged in!
  before_action :logged_in_user, only: [:edit, :update, :show]
  #Require correct user to edit not any user!!!
  before_action :correct_user, only: [:edit, :update]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
    @transfers = @user.transfers
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      UserMailer.welcome_email(@user).deliver
      log_in @user
  		flash[:success] = "Welcome to TransferSmart"
  		redirect_to @user
  	    #handle successful signuo
  	else
    	render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #handle successful edit
      flash[:success] = "Profile updated successfuly"
      redirect_to @user
    else
      flash.now[:danger] = "Invalid editing!"
      render 'edit'
    end
  end

  private

    def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Require login to edit."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      puts 'DEBUG'
      puts @user.id
      puts current_user.id
      unless current_user?(@user)
        flash[:danger] = "Not permitted to edit other user's profile!"
        redirect_to(root_url) 
      end
    end

end
