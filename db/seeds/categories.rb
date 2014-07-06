contents = File.read('db/seeds/categories.txt').split("\n").compact
parent = nil #keeps track of the current parent category
root = [] #this keeps track of the current tree path
level = 1 #keeps track of how deep in the tree
last_created = nil #last created category
repeats = {} #keeps track of any duplicate category names

contents.each do |line|
	if !line.include?("\t") && line.include?("Category") #if it's a main category with no indentation
		name = line.strip.gsub("Category: ", "")
		category = Category.where(name: name).first_or_create
		root[0] = category  
		parent = category
		last_created = category
		level = 2
	elsif line.include?("\t") && line.include?("Category")
		tab_count = line.count "\t"
		if tab_count >= level #logic for increasing increasing level and adding to root
			level += 1
			parent = last_created
		elsif tab_count < level - 1
			level = tab_count + 1
			parent = root[tab_count - 1]
		else
		end
		name = line.strip.gsub("Category: ", "")
		category = Category.where(name: name)
		if category.length > 1 #if there's any duplicates
			if repeats[category.first.name] #increment the duplicate counter so it makes the right parent
				repeats[category.first.name] += 1
			else
				repeats[category.first.name] = 0
			end
		end
		if category.empty? #if its a new category
			category = Category.create name: name, parent: parent
		else
			if category.length > 1 #if its a duplicate
				category = category[repeats[category.first.name]]
			else #if its a non duplicated existing category
				category = category.first
			end
		end
		last_created = category
		root[tab_count] = category #add to root
	elsif line.include?("q: ") #for questions
		last_created.update_attributes question: line.strip[3..-1]
	else #for activities
		Activity.where(name: line.strip, category_id: last_created.id).first_or_create
	end
	p line.strip
end


# puts "creating users..."

# (1..10).each {|n| User.create name: Faker::Name.name }


