require 'rest-client'

helpers do

  def user
  	if session[:email]
  		if @user != nil
  			return @user
  		else
  			@user = User.find_by_email(session[:email])
  			return @user
  		end
  	else
  		return false
  	end
  end
  
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

  def month
    months = {1 => "January", 2 => "February", 3 => "March", 4 => "April", 5 => "May", 6 => "June",
              7 => "July", 8 => "August", 9 => "September", 10 => "October", 11 => "November", 12 => "December"}
    @month = months[Time.now.strftime("%m").to_i]
  end

  def true_when_utilities
  	@house_utilities = Utility.where(:house_id => session[:house_id].to_i)
  end

  def roommates
  	roommates = User.where(:house_id => session[:house_id].to_i) #doesn't work when database is empty
  end

  def authorized?
  	if user
	  	if user.email == session[:email] && user.password_hash == session[:password_hash]
	  		return true
	  	else
	  		return false
	  	end
	  end
  end

  def to_cents(raw_input)
  	(raw_input.to_f * 100).to_i
  end

  def to_dollars(pennies)
    pennies / 100.0
  end

  #takes in raw value of cents and returns string of properly formatted dollar amount.
  def dollar_format(raw)
    raw = raw.to_i
    dollars = (raw / 100)
    cents = (raw % 100)
    formatted = "$#{dollars}.#{cents}"
    if cents < 10
        formatted += "0"
    end
    formatted
  end

  def sum_total
    months_expenditures = Expenditure.where(:house_id => session[:house_id], :active => true).sum("amount")
    this_months_total = Utility.where(:house_id => session[:house_id], :active => true).sum("amount")
    return dollar_format(months_expenditures + this_months_total)
  end

  def your_share
    months_expenditures = Expenditure.where(:house_id => session[:house_id], :active => true).select("user_id, amount")
    this_months_total = Utility.where(:house_id => session[:house_id], :active => true).sum("amount")
    mates = User.where(:house_id => session[:house_id])
    individual_total = this_months_total / mates.length

    share_of_others_due = (months_expenditures.sum("amount") - months_expenditures.where(:user_id => session[:user_id]).sum("amount")) / mates.length
    share_of_own = months_expenditures.where(:user_id => session[:user_id]).sum("amount") * (1 - (1.0 / mates.length))
    share_of_utilities = this_months_total.to_f / mates.length
    total_share = (share_of_utilities + (share_of_others_due - share_of_own)).ceil
    return dollar_format(total_share)
  end

  def send_cashout_msg
    months_expenditures = Expenditure.where(:house_id => session[:house_id], :active => true).select("user_id, amount")
    mates = User.where(:house_id => session[:house_id])
    this_months_total = Utility.where(:house_id => session[:house_id], :active => true).sum("amount") #this is what's being returned
    individual_total = this_months_total / mates.length

    if mates.length > 1
      mates.each do |mate|
        share_of_others_due = (months_expenditures.sum("amount") - months_expenditures.where(:user_id => mate.id).sum("amount")) / mates.length
        share_of_own = months_expenditures.where(:user_id => mate.id).sum("amount") * (1 - (1.0 / mates.length))
        share_of_utilities = this_months_total.to_f / mates.length
        total_share = (share_of_utilities + (share_of_others_due - share_of_own)).ceil
        text = "Hello #{mate.first_name}! We hope you've had a good month. #{session[:first_name]} has ended this month's billing cycle, which means it's time to pay the piper!\n\nThis month's total for rent and utilities was #{dollar_format(this_months_total)}, which works out to #{dollar_format(share_of_utilities.ceil)} per roommate. However, we've adjusted this number with regards to how much each roommate has already spent on communal items, so with this taken into account, your GRAND TOTAL comes out to #{dollar_format(total_share)}.\n\nThank you for using HouseKeeper! :)"
        send_message(mate.email, "Bills In For This Month!", text)
      end
    end
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
















