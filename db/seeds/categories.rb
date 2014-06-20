contents = File.read('db/seeds/categories.txt').split("\n").compact
parent = nil
level = 1
last_created = nil

puts "Creating Categories..."


contents.each do |line|
	if !line.include?("\t") && line.include?("Category")
		name = line.strip.gsub("Category: ", "")
		category = Category.create name: name
		parent = category
		last_created = category
		level = 2
	elsif line.include?("\t") && line.include?("Category")
		tab_count = line.count "\t"
		if tab_count >= level 
			level += 1
			parent = last_created
		end
		name = line.strip.gsub("Category: ", "")
		category = Category.create name: name, parent: parent
		last_created = category
	else
		Activity.create name: line.strip, category_id: last_created.id
	end
	p line.strip
end


puts "creating users..."

(1..200).each {|n| User.create name: "user-#{n}" }


