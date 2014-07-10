"Creating User Interests"

all_ids = Activity.all.order(:id).pluck(:id)
start = all_ids[0]
last = all_ids[-1]

User.all.each do |user|
	rand_act_ids = (start..last).to_a.shuffle[0..30]
	user.activities << Activity.find(rand_act_ids)
end

