require 'rest-client'

helpers do

  
  def login
    user = User.find_by_primary_email(params[:primary_email])
    if user
      if BCrypt::Password.new(user.password_hash) == params[:password]
        session[:user_id] = user.id
        session[:primary_email] = user.primary_email
        session[:first_name] = user.first_name
        session[:last_name] = user.last_name
        {"user now logged in" => true}.to_json
        # redirect '/'
      end
    end
    # redirect '/register_house'
  end

  def logout
    session.clear
  end

  # Input: :primary_email, :first_name, :last_name, :password
  def create_user(data) # %%%
    User.create(:primary_email => data['primary_email'], :first_name => data['first_name'],
                :last_name => data['last_name'], :password_hash => BCrypt::Password.create(data['password']))
    "success".to_json
  end

  # Input: :member_email, :user_id, :display_name
  # Needs to pass user_id to work. Improve this (and elsewhere where same trick is used) when working on security
  def create_fishbowl(data)
    parsed_email = /^(.+)@(.+)/.match(data['member_email'])
    local_part = parsed_email[1]
    domain_part = parsed_email[2]
    Community.create(:domain_part => domain_part, :display_name => data['display_name'])
    Membership.create(:member_email => data['member_email'], :user_id => data['user_id'].to_i,
                      :community_id => Community.find_by_domain_part(domain_part).id)
    "success".to_json
  end

  # Input: :member_email, :user_id
  def join_fishbowl
    parsed_email = /^(.+)@(.+)/.match(data['member_email'])
    local_part = parsed_email[1]
    domain_part = parsed_email[2]
    fishbowl_to_join = Community.find_by_domain_part(domain_part)
    if !Membership.find_by(community_id: fishbowl_to_join.id, user_id: data['user_id'])
      if fishbowl_to_join
        Membership.create(:member_email => data['member_email'], :user_id => data['user_id'].to_i,
                          :community_id => data['community_id'].to_i)
        "success".to_json
      else
        "not_found".to_json
      end
    else
      "already_a_member".to_json
    end
  end

  def populate_feed(data)
    user_communities = Membership.where(user_id: data['user_id']).map { |membership| membership.community_id }
    all_posts = Post.where(community_id: user_communities)
    all_posts.map do |post|
      mine = post.user_id == data['user_id']
      {title: post.title, score: post.score, mine: mine}
    end.to_json
  end



  def send_message(to, subject, text)
    RestClient.post "https://api:key-2yysjtw83re60djtlw22w4flfnyl8wt1"\
    "@api.mailgun.net/v2/sandboxfac2f1ef29a84995bb38573a3c2b060d.mailgun.org/messages",
    :from => "House Keeper <postmaster@sandboxfac2f1ef29a84995bb38573a3c2b060d.mailgun.org>",
    :to => to,
    :subject => subject,
    :text => text
  end
end
















