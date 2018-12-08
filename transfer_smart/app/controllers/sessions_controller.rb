class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if(user && user.authenticate(params[:session][:password]))
  		#log in user and redirect to show
  	else
  		flash.now[:danger] = 'Invalid email/password combination'
  	    #because there is no redirect we use flash.now so as not to display message two times.Render does not count as a request
  		render 'new' #to not block the login button --> Refresh page!

  	end
  end

  def destroy	
  end
end