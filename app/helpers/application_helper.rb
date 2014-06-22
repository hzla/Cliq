module ApplicationHelper
	def broadcast(channel, json)
	  message = {:channel => channel, :data => json, :ext => {:auth_token => FAYE_TOKEN}}
	  uri = URI.parse("http://localhost:9292/faye")
	  Net::HTTP.post_form(uri, :message => message.to_json)
	end
end


