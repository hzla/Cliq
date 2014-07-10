users = User.all

puts "seeding user conversations, this could take while..."

users.each do |user|
	1.times do 
		other_user = users.sample
		conversation = Conversation.create name: other_user.id

		2.times do 
			Message.create user_id: user.id, conversation_id: conversation.id, body: Faker::Lorem.paragraph
			Message.create user_id: other_user.id, conversation_id: conversation.id, body: Faker::Lorem.paragraph
		end
		user.conversations << conversation
		other_user.conversations << conversation
	end
end