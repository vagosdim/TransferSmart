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

end
