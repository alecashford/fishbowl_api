class Thread < ActiveRecord::Base
	belongs_to :reply
	belongs_to :child, :class_name => "Reply"
end