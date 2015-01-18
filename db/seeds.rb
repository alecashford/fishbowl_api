require 'faker'

500.times do
	User.create(primary_email: Faker::Internet.free_email, first_name: Faker::Name.first_name,
							last_name: Faker::Name.last_name, password_hash: BCrypt::Password.create("password"))
end

(1..500).each do |x|
	Array(1..rand(3) + 1).each do |y|
		Membership.create(member_email: Faker::Internet.email, user_id: x, community_id: y)
	end
end

Community.create(domain_part: "willamette.edu", display_name: "Willamette University", creator_id: 1)
Community.create(domain_part: "kenyon.edu", display_name: "Kenyon College", creator_id: 2)
Community.create(domain_part: "deloitte.com", display_name: "Deloitte", creator_id: 1)

150.times do
	Post.create(title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph(rand(12) + 1),
							score: rand(50), user_id: (rand(500) + 1), community_id: (rand(3) + 1))
end

(1..150).each do |i|
	Reply.create(content: Faker::Lorem.paragraph(rand(7) + 1), score: rand(25), user_id: (rand(500) + 1),
							 post_id: (rand(50) + 1))
end