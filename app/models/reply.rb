class Reply < ActiveRecord::Base
	belongs_to :user
	belongs_to :post

	has_many :nodes_as_parent, :foreign_key => 'parent_id', :class_name => 'Node'
	has_many :nodes_as_child, :foreign_key => 'child_id', :class_name => 'Node'
	has_many :parents, :through => :nodes_as_child
	has_many :children, :through => :nodes_as_parent

	# acts_as_nested_set

end