class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :content
      t.integer :score, :deault => 0
      t.integer :user_id
      t.integer :post_id
      t.boolean :anonymous, :default => true
      
      t.timestamps
    end
  end
end