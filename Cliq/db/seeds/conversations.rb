users = User.all

users.each do |user|
	p user.id
	6.times do 
		other_user = users.sample
		conversation = Conversation.create name: other_user.id

		3.times do 
			Message.create user_id: user.id, conversation_id: conversation.id, body: Faker::Lorem.paragraph
			Message.create user_id: other_user.id, conversation_id: conversation.id, body: Faker::Lorem.paragraph
		end
		user.conversations << conversation
		other_user.conversations << conversation
	end
end