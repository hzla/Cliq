require 'wikipedia'
acts = Activity.where activty_pic: nil
acts.each do |act|
	act.remove_activity_pic!
	act.save
	entry = Wikipedia.find act.name
	urls = entry.image_urls
	if urls
		act.update_attributes remote_activity_pic_url: urls.first
		act.save
		p urls.first
		p act.name
	end
end


