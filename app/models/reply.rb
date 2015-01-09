class Reply < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
	# has_many :threads
	# has_many :children, :through => :threads
	# # has_many :inverse_threads, :class_name => "Thread", :foreign_key => "child_id"
	# # has_many :inverse_children, :through => :inverse_threads, :source => :reply

	acts_as_tree order: 'score'

end