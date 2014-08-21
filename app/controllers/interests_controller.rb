class InterestsController < ApplicationController
	include SessionsHelper

	# if a post to create is triggered, destroy the event
	# this is so that people can click on the interest again to undo the like
	# like the cat_interest if it hasn't been liked
	# need to remember to destroy cat_interest if there are no interests liked
	def create
		act = Activity.find(params[:act_id])
		cat = act.category
		int = Interest.where(activity_id: params[:act_id], user_id: current_user.id).first
		if int
			int.destroy
			cat.popularity -= 1
			cat.save
			render nothing: true and return
		end
		interest = Interest.find_or_create_by activity_id: params[:act_id], user_id: current_user.id
		cat.popularity += 1
		cat.save
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