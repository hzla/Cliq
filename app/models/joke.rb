class Joke < ActiveRecord::Base
	attr_accessible :body, :punchline

	def self.random
    offset(rand(count)).first
  end
end

