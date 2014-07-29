class UsersController < ApplicationController
	before_filter :get_user

	def show
		if params[:id].to_i != current_user.id
			redirect_to user_path current_user 
			return
		end
		@welcome = params["welcome"]
		@category = Category.where(name: "Do").first
		@format = Category.self_format
		@formatted_interests = @user.formatted_interests
		respond_to do |format|
  		format.html 
  		format.json { render :json => @user }
		end
	end

	def other
		@user = User.find params[:id]
		@format = Category.other_format @user.first_name, @user.sex
		@formatted_interests = @user.formatted_interests
		render layout: false
	end

	def send_activation
		current_user.update_attributes email: params[:email]
		UserMailer.welcome_email(current_user, params[:email]).deliver
		render nothing: true
	end

	def activate
		session[:user_id] = params[:id] if params[:code] == ENV["PASSWORD"]
		if params[:code] == @user.activation
			session[:user_id] = @user.id
			@user.activate
			@message = "You have been activated"
			redirect_to search_path and return
		else
			@message = "Activation Failed"
			redirect_to search_path
		end
	end

	def search
		@results = current_user.search_similar current_user.activities
		@category = Category.where(name: "Do").first
		@user_empty = current_user.interests.empty?
	end

	def main
		@results = current_user.search_similar current_user.activities
		@category = Category.where(name: "Do").first
		@user_empty = current_user.interests.empty?
	end

	def search_results #add support for searching location without ids
		if params[:ids] == "" 
			if params[:location_id] == "" && params[:location] == ""
				results = current_user.search_similar current_user.activities
			else
				if params[:location_id] != "" && params[:location] != ""
					location = Location.find params[:location_id]
				elsif params[:location] != ""
					stored_location = Location.where(name: params[:location]).first
					if stored_location
						location = stored_location
					else
						cords = Geocoder.coordinates params[:location]
						if cords
							location = Location.create name: params[:location], latitude: cords[0], longitude: cords[1]
							LocationSuggestion.create term: location.name, location_id: location.id
						else
							location = "invalid"
						end
					end
				else
					location = nil
				end
				results = current_user.search_similar current_user.activities, location
			end
			if params[:type] == "swipe"
				render partial: "swipe_results", locals: {results: results}
				return
			else
				render partial: "search_results", locals: {results: results}
				return
			end
		end


		if params[:location_id] != "" && params[:location] != ""
			location = Location.find params[:location_id]
		elsif params[:location] != ""
			cords = Geocoder.coordinates params[:location]
			if cords
				location = Location.create name: params[:location], latitude: cords[0], longitude: cords[1]
			else
				location = "invalid"
			end
		else
			location = nil
		end
		results = current_user.search_similar(Activity.parse_interests(params[:ids]), location)
		if params[:type] == "swipe"
			render partial: "swipe_results", locals: {results: results}
			return
		end
		render partial: "search_results", locals: {results: results}
	end

	def feedback
		content = params[:content]
		FeedbackMailer.feedback(content, current_user).deliver
		render nothing: true
	end

	def settings
		redirect_to settings_path(current_user) if current_user.id != params[:id].to_i
	end

	def update
		old_address = current_user.address
		if old_address != params[:user][:address]
			new_address = Geocoder.search(params[:user][:address])[0]
		else
			new_address = "same"
		end
	
		if new_address != nil && new_address != "same"
			cords = new_address.coordinates
			current_user.update_attributes latitude: cords[0], longitude: cords[1]
			current_user.update_attributes address: new_address.data["address_components"][0]["long_name"]
			render nothing: true
			return
		elsif new_address == "same"
			current_user.update_attributes params[:user]
			render nothing: true
			return
		else
			render json: {error: true}
		end
	end

	def destroy
		current_user.messages.map(&:conversation).uniq.each do |convo|
			convo.destroy
		end
		current_user.destroy
		redirect_to root_path
	end

	def invite_friends
		UserMailer.invite_email(current_user, params[:email]).deliver
		render nothing: true
	end

	def block
		id = params[:id]
		current_list = current_user.blacklist
		current_list += ",#{id}"
		current_user.update_attributes blacklist: current_list

		other_user = User.find params[:id]
		other_list = other_user.blacklist
		other_list += ",#{current_user.id}"
		other_user.update_attributes blacklist: other_list

		render nothing: true 
	end

private
	
	def get_user
		@user = params[:user_id] ? User.find(params[:user_id]) : User.find(params[:id]) if params[:id]
	end

end