"Creating User Interests"


User.all.each do |user|
	rand_cat_ids = (1..Category.count).to_a.shuffle[0..20]
	rand_act_ids = (1..Activity.count).to_a.shuffle[0..30]
	user.categories << Category.find(rand_cat_ids)
	user.activities << Activity.find(rand_act_ids)
end

