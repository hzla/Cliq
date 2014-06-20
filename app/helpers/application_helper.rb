module ApplicationHelper
	def broadcast(channel, json)
	  message = {:channel => channel, :data => json, :ext => {:auth_token => FAYE_TOKEN}}
	  uri = URI.parse("http://faye-server-10.herokuapp.com/faye")
	  Net::HTTP.post_form(uri, :message => message.to_json)
	end
end
