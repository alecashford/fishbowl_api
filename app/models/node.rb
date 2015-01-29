class Node < ActiveRecord::Base
	# belongs_to :reply
	# belongs_to :child, :class_name => 'Reply'
	belongs_to :parent, :foreign_key => 'parent_id', :class_name => 'Reply'
	belongs_to :child, :foreign_key => 'child_id', :class_name => 'Reply'
end