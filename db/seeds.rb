require 'faker'
new_house = House.create(:house_number => "1783", :street => "Church St.", :city => "Salem",
			 :state => "Oregon", :zip_code => "97302", :country => "USA")
new_house.generate_code

User.create(:first_name => "Alec", :last_name => "Ashford", :email => "ashford91@gmail.com",
			:phone => "4156402665", :password_hash => BCrypt::Password.create("pass"),
			:house_id => 1)
User.create(:first_name => "Noam", :last_name => "KZ", :email => "nkz124@gmail.com",
			:phone => "1111111111", :password_hash => BCrypt::Password.create("pass"),
			:house_id => 1)
User.create(:first_name => "Phil", :last_name => "Hellmuth", :email => "philliam222@gmail.com",
			:phone => "2222222222", :password_hash => BCrypt::Password.create("pass"),
			:house_id => 1)
User.create(:first_name => "Aaron", :last_name => "Ollis", :email => "ollis9358@gmail.com",
			:phone => "3333333333", :password_hash => BCrypt::Password.create("pass"),
			:house_id => 1)

Utility.create(:house_id => 1, :utility_type => "Gas", :provider => "NW Natural", :amount => 10695)
Utility.create(:house_id => 1, :utility_type => "Electric", :provider => "PGE", :amount => 8820)
Utility.create(:house_id => 1, :utility_type => "Rent", :amount => 120000)

Expenditure.create(:user_id => 1, :house_id => 1, :amount => 12000, :note => "booze")
Expenditure.create(:user_id => 2, :house_id => 1, :amount => 6645, :note => "soap")

# create a few users

#TODO: Once you have implemented BCrypt - you can use these to seed your database.


# User.create :name => 'Dev Bootcamp Student', :email => 'me@example.com', :password => 'password'
# 5.times do
#   User.create :name => Faker::Name.name, :email => Faker::Internet.email, :password => 'password'
# end
