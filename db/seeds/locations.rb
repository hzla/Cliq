contents = File.read('db/seeds/locations.txt').split("\n").compact

contents.each do |city|
	p city
	Location.create address: city, name: city

end