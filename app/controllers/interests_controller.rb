class InterestsController < ApplicationController
	include SessionsHelper

	def create
		act = Activity.find(params[:act_id])
		interest = Interest.create activity_id: params[:act_id], user_id: current_user.id
		CatInterest.find_or_create_by(user_id: current_user.id, category_id: act.category.id)
		render partial: 'chosen_act', locals: {act: act, interest: interest}
	end

	def destroy
		interest = Interest.find(params[:id])
		act = interest.activity
		interest.destroy
		render partial: 'act', locals: {act: act }
	end

end