module SessionsHelper
	def current_user
		if session[:user_id] 
			User.where('id in (?)', session[:user_id]).first
		else 
			nil
		end
	end
end