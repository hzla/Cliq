contents = File.read('db/seeds/categories.txt').split("\n").compact
parent = nil
root = []
level = 1
last_created = nil

contents.each do |line|
	if !line.include?("\t") && line.include?("Category")
		name = line.strip.gsub("Category: ", "")
		category = Category.where(name: name).first_or_create
		root[0] = category 
		parent = category
		last_created = category
		level = 2
	elsif line.include?("\t") && line.include?("Category")
		tab_count = line.count "\t"
		if tab_count >= level 
			level += 1
			parent = last_created
		elsif tab_count < level - 1
			level = tab_count + 1
			parent = root[tab_count - 1]
		else
		end
		name = line.strip.gsub("Category: ", "")
		category = Category.where(name: name)
		if category.empty?
			category = Category.create name: name, parent: parent
		else
			category = category.first
		end
		last_created = category
		root[tab_count] = category
	elsif line.include?("q: ")
		last_created.update_attributes question: line.strip[3..-1]
	else
		Activity.where(name: line.strip, category_id: last_created.id).first_or_create
	end
	p line.strip
end


# puts "creating users..."

# (1..10).each {|n| User.create name: Faker::Name.name }


