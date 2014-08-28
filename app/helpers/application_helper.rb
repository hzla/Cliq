module ApplicationHelper
	def broadcast(channel, json)
	  message = {:channel => channel, :data => json, :ext => {:auth_token => FAYE_TOKEN}}
	  uri = URI.parse("http://faye-server-10.herokuapp.com/faye")
	  Net::HTTP.post_form(uri, :message => message.to_json)
	end

	def doing? name
		Category.find(request.original_url.split("/")[-2]).name == name ? "doing" : ""  
	end

	def random_joke
		Joke.random
	end

	def random_animal
		url_name = "a" + (rand(20) + 1).to_s + ".jpg"
		'https://s3.amazonaws.com/CliqBucket/Jokes/' + url_name
	end
end


