# puts "creating Events"

# (6..10).each do |n|
# 	event = Event.create title: "event-#{n}", description: "This is a description for an event", location: "55 West 5th Ave, San Mateo", start_time: (Time.now - 50.hours)
# 	event.users << User.all
# 	event.save
# end

# Event.all.each do |event|
# 	event.excursions.sample.update_attributes created: true
# end