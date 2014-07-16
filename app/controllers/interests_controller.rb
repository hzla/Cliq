class InterestsController < ApplicationController
	include SessionsHelper

	def create
		act = Activity.find(params[:act_id])
		interest = Interest.find_or_create_by activity_id: params[:act_id], user_id: current_user.id
		CatInterest.find_or_create_by(user_id: current_user.id, category_id: act.category.id)
		render nothing: true and return if params[:nothing] == true
		render partial: 'chosen_act', locals: {act: act, interest: interest}
	end

	def destroy
		interest = Interest.find(params[:id])
		act = interest.activity
		interest.destroy
		render partial: 'act', locals: {act: act }
	end

	def quick_create
		if params[:act_id][0] == "A"
			act_id = params[:act_id][2..-1].to_i 
			act = Activity.find act_id
			interest = Interest.find_or_create_by activity_id: act_id, user_id: current_user.id
			CatInterest.find_or_create_by(user_id: current_user.id, category_id: act.category.id)
			render nothing: true
			return
		else
			cat_id = params[:act_id][2..-1].to_i 
			CatInterest.find_or_create_by user_id: current_user.id, category_id: cat_id
			render nothing: true
		end
	end

end