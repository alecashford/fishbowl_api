class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.integer :score
      t.integer :user_id
      t.integer :community_id
      t.boolean :anonymous, :default => true

      t.timestamps
    end
  end
end