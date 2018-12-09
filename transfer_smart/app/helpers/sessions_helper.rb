module SessionsHelper
	
	def log_in(user)
		session[:user_id] = user.id
	end
     
    #find_by returns nil if instead find raises exception
    #Returns the current logged-in user (if any).
	def current_user
		if session[:user_id]
			@current_user ||= User.find_by(id: session[:user_id])
		end
	end

	# '?' indicates tha the result is boolean
	def logged_in?
		!current_user.nil?
	end

	def log_out
		session.delete(:user_id)
		@current_user = nil
	end

	# Returns true if the given user is the current user.
    def current_user?(user)
      user == current_user
    end

    #if GET Request  then store the url trying to access
    def store_location
    	if request.get?
    	  session[:forwarding_url] = request.original_url
    	end
    end

    #Redirect to stored url if one exists else to default
    def redirect_back_or(default)
    	redirect_to(session[:forwarding_url] || default)
    	session.delete(:forwarding_url)
    end

end
