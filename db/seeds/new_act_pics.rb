acts = Activity.where(has_pic: false)

bing = Bing.new ENV['BING_ID'], 1, "Image"
failures = []

acts.each do |act|
	name = act.name.split.join('_')
	p act.name
	image = bing.search(act.name)[0][:Image]
	if image
		url = image[0][:MediaUrl]
		ext = url.split(".").last
		
		begin
	    file = URI.parse url
			File.open("activities/#{name}.#{ext[0..2]}", "wb") {|f| f.write(file.read)}
			act.update_attributes has_pic: true
  	rescue Exception
    	failures << act
  	end
	end
end

p failures
p failures.count
