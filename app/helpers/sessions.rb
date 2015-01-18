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
  # Output: id of new community
  # Needs to pass user_id to work. Improve this (and elsewhere where same trick is used) when working on security
  def create_fishbowl(data)
    parsed_email = /^(.+)@(.+)/.match(data['member_email'])
    local_part = parsed_email[1]
    domain_part = parsed_email[2]
    new_community = Community.create(:domain_part => domain_part, :display_name => data['display_name'], :creator_id => data['user_id'])
    Membership.create(:member_email => data['member_email'], :user_id => data['user_id'].to_i,
                      :community_id => Community.find_by_domain_part(domain_part).id)
    new_community.id.to_json
  end

  # Input: :member_email, :user_id
  # Output: status code
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

  # Input: :user_id
  # Output: JSON obj in format #=> [{id: int, title: 'str', score: int, community_id: int, mine: 'bool', content: 'str', created_at: date}]
  def populate_feed(data)
    user_communities = Membership.where(user_id: data['user_id']).map { |membership| membership.community_id }
    all_posts = Post.where(community_id: user_communities)
    formatted_posts = all_posts.map do |post|
      mine = post.user_id == data['user_id']
      {id: post.id, title: post.title, score: post.score, community_id: post.community_id, mine: mine, content: post.content, created_at: post.created_at}
    end.reverse
    formatted_posts.to_json
  end

  # Input: :user_id, :community_id
  def populate_specific_feed(data)
    all_posts = Post.where(community_id: data['community_id'])
    formatted_posts = all_posts.map do |post|
      mine = post.user_id == data['user_id']
      {id: post.id, title: post.title, score: post.score, mine: mine, content: post.content, created_at: post.created_at}
    end.reverse
    bool = Community.find(data['user_id'])
    {owner: bool, posts: formatted_posts}.to_json
  end

    # Started the work for hash lookup here, may finish later
  # def populate_feed(data)
  #   user_communities = Membership.where(user_id: data['user_id']).map { |membership| membership.community_id }
  #   all_posts = Post.where(community_id: user_communities)
  #   formatted_posts = {}
  #   all_posts.each do |post|
  #     mine = post.user_id == data['user_id']
  #     formatted_posts[post.id] = {title: post.title, score: post.score, mine: mine, content: post.content, created_at: post.created_at}}
  #   end
  #   index_list = {}
  #   formatted_posts.each_with_index do |post, index|
  #     index_list[index] = post[:id]}
  #   end
  #   p index_list
  #   {index: index_list, posts: formatted_posts}.to_json
  # end

  # Input: :post_id
  # Output: JSON obj ranked by score in format #=> [{content: 'str', score: int, created_at: date}]
  # Improve this when I implement nested comments!!!
  def get_comments(data)
    comments = Reply.where(post_id: data['post_id'])
    comments.to_json
    # comments.map do |comment|
    #   # {comment.content, content.score, content.created_at}
    # end
    # # comments.sort! { |x, y| x['score'] <=> y['score'] }.to_json
    # # p "it got here..."
    # ["hello there"].to_json
  end

  # Input: :user_id
  # Output: {owned: [obj], not_owned: [obj]}
  def my_groups(data)
    user_communities = Membership.where(user_id: data['user_id']).map { |membership| membership.community_id }
    all_of_my_communities = Community.find(user_communities)
    return_payload = {'owned' => [], 'not_owned' => []}
    all_of_my_communities.each do |community|
      if community.creator_id == data['user_id']
        return_payload['owned'] << community
      else
        return_payload['not_owned'] << community
      end
    end
    return_payload.to_json
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
















