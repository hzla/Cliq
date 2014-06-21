class PartnersController < ApplicationController
	include SessionsHelper

	def show
		@partner = Partner.find params[:id]
		respond_to do |format|
  		format.html 
  		format.json { render :json => @partner }
		end
	end
end