#1000 users
#210 categories, 10 main categories each with 20 sub categories
#2000 activities 10 per sub category
start = Time.now
puts "creating users please wait..."

(1..1000).each {|n| User.create name: "user-#{n}" }

puts "creating categories..."

(1..20).each {|n| Category.create name: "category-#{n}" }

puts "creating activities..."

(1..10).each do |n| 
	(1..20).each do |x| 
		cat = Category.create name: "category-#{n}/sub-#{x}", parent_id: n
		(1..10).each do |y|
			cat.activities << Activity.create(name: "category-#{n}/sub-#{x}/activity-#{y}")
		end
	end
end

puts "creating user interests..."

User.all.each do |user|
	rand_cat_ids = (1..Category.count).to_a.shuffle[0..9]
	rand_act_ids = (1..Activity.count).to_a.shuffle[0..9]
	user.categories << Category.find(rand_cat_ids)
	user.activities << Activity.find(rand_act_ids)
end

finish = Time.now

time = finish - start
puts "all done! It took #{time}"



