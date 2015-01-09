class User < ActiveRecord::Base
	has_many :memberships
	has_many :communities, through: :memberships
	has_many :posts
	has_many :replies
end