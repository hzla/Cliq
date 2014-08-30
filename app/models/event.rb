class Event < ActiveRecord::Base
	belongs_to :partner
	has_many :users, through: :excursions
	has_many :excursions, dependent: :destroy 
	has_many :conversations, dependent: :destroy
	mount_uploader :image, ImageUploader

	validates :title, presence: true
	validates :start_time, presence: true

	attr_accessible :view, :creator_id, :title, :description, :location, :start_time, :end_time, :image, :attended, :partner_id, :quantity, :remote_image_url, :closed, :music, :discussion, :activity, :party, :show, :food, :games, :twenty_one, :paid, :event_type, :messages_count, :shaman
	
	def html_classes c_user
		"#{ ' today' if today?(c_user)}#{ ' tomorrow' if tommorow?(c_user)} #{ date(c_user)} #{tags}#{ ' hosting' if c_user == user}"
	end

	def self.adjust_time adjustment
		all.each do |event|
			event.start_time += adjustment.hours
			event.save
		end
	end

	def self.change_types
		Event.where(event_type: "Work").update_all event_type: "Hangout"
		Event.where(event_type: "Play").update_all event_type: "Party"
		Event.where(event_type: "Chill").update_all event_type: "Event"
	end

	def self.assign_and_return_new params
		total_params = params[:event]
		tags = params[:tags].downcase.split(',').map do |t|
			{t.to_sym => true}
		end.inject Hash.new, :merge
		total_params = total_params.merge tags
		total_params = total_params.merge({paid: true}) if params[:requirements] && params[:requirements].include?("Paid")
		Event.new total_params
	end

	def conversation
		conversations.first
	end

	def shortened_title
		title.length > 95 ? title[0..93] + "..." : title
	end

	def date user
		(start_time + user.timezone.hours).strftime("%B-%e").gsub("- ", "-")
	end

	def tags
		types = "#{event_type},#{' show' if show},#{' activity' if activity},#{' music' if music},#{' discussion' if discussion},#{' drinks' if party},#{' food' if food},#{' games' if games},#{' shaman' if shaman}"
		(types.split(",") - [""]).join.downcase
	end

	def self.update_message_counts
		all.each do |event|
			next if !event.conversations.first
			count = event.conversations.first.messages.count
		end
	end

	def self.update_creators
		all.each do |event|
			event.update_attributes creator_id: event.creator.id
		end
	end

	def user
		User.find creator_id
	end

	def creator
		excursions.where(created: true)[0].user if excursions.where(created: true)[0]
	end

	def full_time user
		if !today? user
			stime = (start_time + user.timezone.hours).strftime("%B %d at %I:%M %p")
		else
			stime = (start_time + user.timezone.hours).strftime("%B %d at %I:%M %p") 
		end
	end

	def time user
		stime = (start_time + user.timezone.hours).strftime("%I:%M %p").downcase 
	end

	def today? user
		start_time - Time.now.utc < 24.hours && (start_time + (user.timezone.hours)).beginning_of_day.day == user.user_time.beginning_of_day.day
	end

	def tommorow? user
		start_time - Time.now.utc < 48.hours && ((start_time + (user.timezone.hours)).beginning_of_day.day - 1) == user.user_time.beginning_of_day.day
	end

	def attendees
		excursions.where(accepted: true)
	end

	def accepted?
		excursions.where(accepted: false).empty?
	end

	def passed_by? user
		!Excursion.where(user_id: user.id, event_id: id, passed: true ).empty?
	end

	def untouched_by? user
		Excursion.where(user_id: user.id, event_id: id).empty?
	end

	def people_count
		excursions.where(accepted: true).count
	end

	def short_location
		location.length > 24 ? location[0..23] + ".." : location
	end

	def self.open user
		where('start_time > (?)', (user.user_time - 6.hours) ).order(:start_time).select { |event| !event.passed_by?(user) }
	end

	def self.hosted_by user
		invite_excursions = user.excursions.where(created: true)
		invite_excursions.map(&:event).compact.select { |event| event.start_time > (user.user_time - 6.hours) }.sort_by(&:start_time)
	end

	def self.past user
		user.excursions.where(accepted: true).map(&:event).select { |event| event.start_time < (user.user_time - 6.hours) }.sort_by(&:start_time).reverse
	end

	def self.joined_by user
		user.excursions.where(accepted: true).map(&:event).select { |event| event.start_time > (user.user_time - 6.hours) }.sort_by(&:start_time)
	end 

	def self.messaged_joined_by user
		user.excursions.where(accepted: true).map(&:event).select { |event| event.start_time > (user.user_time - 6.hours) && event.messages_count != 0 }.sort_by(&:start_time)
	end

	def joined_by user
		!excursions.where(accepted: true, user_id: user.id).empty?
	end
end