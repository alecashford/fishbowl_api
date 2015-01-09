get '/' do
  "success".to_json
end

post '/' do 
  
end

# #----------- SESSIONS -----------

get '/logout' do
  session.clear
  redirect '/'
end

post '/login' do
  login
end

# #----------- USERS -----------

# Input: :primary_email, :first_name, :last_name, :password
post '/create-user' do
	User.create(:primary_email => params[:primary_email], :first_name => params[:first_name],
							:last_name => params[:last_name], :password_hash => BCrypt::Password.create(params[:password]))
	"success".to_json
end

# Input: :member_email, :user_id, :display_name
# Needs to pass user_id to work. Improve this (and elsewhere where same trick is used) when working on security
post '/create-fishbowl' do
	parsed_email = /^(.+)@(.+)/.match(params[:member_email])
	local_part = parsed_email[1]
	domain_part = parsed_email[2]
	Community.create(:domain_part => domain_part, :display_name => params[:display_name])
	Membership.create(:member_email => params[:member_email], :user_id => params[:user_id].to_i,
										:community_id => Community.find_by_domain_part(domain_part).id)
	"success".to_json
end

# Input: :member_email, :user_id
post '/join-fishbowl' do
	parsed_email = /^(.+)@(.+)/.match(params[:member_email])
	local_part = parsed_email[1]
	domain_part = parsed_email[2]
	fishbowl_to_join = Community.find_by_domain_part(domain_part)
	if !Membership.find_by(community_id: fishbowl_to_join.id, user_id: params[:user_id])
		if fishbowl_to_join
			Membership.create(:member_email => params[:member_email], :user_id => params[:user_id].to_i,
												:community_id => params[:community_id].to_i)
			"success".to_json
		else
			"not_found".to_json
		end
	else
		"already_a_member".to_json
	end
end

# Input: :user_id
# Output: JSON obj in format #=> [{title: 'str', score: int, community_id: int, mine: 'bool'}]
post '/popultate-feed' do
	user_communities = Membership.where(params[:user_id]).map { |membership| membership.community_id }
	all_posts = Post.where(community_id: user_communities)
	# Test from here on once sample data has been created
	all_posts.map do |post|
		mine = post.user_id == params[:user_id]
		{title: post.title, score: post.score, mine: mine}
	end.to_json
end

post '/create-post' do

end


# post '/add-user' do
#   content_type :json
#   User.create(:first_name => params[:first_name], :last_name => params[:last_name], :email => params[:email],
#               :phone => params[:phone], :password_hash => BCrypt::Password.create(params[:password]),
#               :house_id => session[:house_id])
#   "#Here are the params: #{params[:first_name]} #{params[:last_name]}"
# end # should be combined with create user, above. Currently only services the ajax popup box

# post '/create-house' do
#   new_house = House.create(:house_number => params[:house_number], :street => params[:street], :city => params[:city],
#                 :state => params[:state], :zip_code => params[:zip_code], :country => params[:country])
#   new_house.generate_code
#   session[:house_id] = new_house.id
#   Utility.create(:house_id => session[:house_id], :utility_type => "Rent", :amount => to_cents(params[:rent]), :provider => "")
#   erb :register_house
#   redirect '/register-user'
# end

# post '/populate' do
#   content_type :json
#   util_var = Utility.where(:house_id => session[:house_id], :active => true)
#   exp_var = Expenditure.where(:house_id => session[:house_id], :active => true)
#   json_obj = []
#   util_var.each do |obj|
#     json_obj << {utility: {utility_type: obj.utility_type, provider: obj.provider, amount: dollar_format(obj.amount)}}
#   end
#   exp_var.each do |obj|
#     first_name = User.find(obj.user_id).first_name
#     json_obj << {utility: {utility_type: obj.note, provider: first_name, amount: dollar_format(obj.amount)}}
#   end
#   return json_obj.to_json
# end

# get '/add-utility' do
# erb :add_utility
# end

# post '/create-utility' do
#   content_type :json
#   p params
#   Utility.create(:house_id => session[:house_id], :utility_type => params[:utility_type], :provider => params[:provider],
#                  :amount => to_cents(params[:amount]))

#   {utility_type: params[:utility_type], provider: params[:provider], amount: dollar_format(to_cents(params[:amount]))}.to_json
# end

# post '/login' do
#   redirect '/'
# end

# post '/add-expenditure' do
#   content_type :json
#   new_expense = Expenditure.create(:user_id => session[:user_id], :amount => to_cents(params[:cost]), :note => params[:note], :house_id => session[:house_id])
#   name_of_buyer = User.where(:id => new_expense.user_id)[0].first_name
#   {first_name: name_of_buyer, note: params[:note], amount: dollar_format(to_cents(params[:cost]))}.to_json
# end

# post '/call-in' do
#   mates = User.where(:house_id => session[:house_id])
#   text = "One of your roomates has called in for monthly billing. If you haven't already done so, log on to House Keeper and input any utility bills or expenditures you may be responsible for. Thank you!"
#   mates.each do |mate|
#     send_message(mate.email, "Calling In Bills For This Month!", text)
#   end
# end

# post '/cash-out' do
#   send_cashout_msg
#   Utility.where(:active => true, :house_id => session[:house_id]).update_all(:active => false)
#   Expenditure.where(:active => true, :house_id => session[:house_id]).update_all(:active => false)
#   return "Blank slate"
#   redirect '/'
# end

# post '/make-dollar' do
#   content_type :json
#   dollars = dollar_format(params[:amount])
#   {amount: dollars}.to_json
# end

# post '/update-splash-values' do

# end

# post '/sum-total' do
#   content_type :json
#   {total: sum_total, your_share: your_share}.to_json
# end




