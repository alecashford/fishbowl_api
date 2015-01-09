class CreateThreads < ActiveRecord::Migration
  def change
    create_table :threads do |t|
      t.integer :reply_id
      t.integer :child_id

      t.timestamps
    end
  end
end