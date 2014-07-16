require 'wikipedia'
acts = Activity.where activity_pic: nil
acts.each do |act|
	p act.name
	entry = Wikipedia.find act.name
	urls = entry.image_urls
	if !urls.empty?
		act.update_attributes remote_activity_pic_url: urls.first
		act.save
		p urls.first
	end
end


