class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :domain_part
      t.string :display_name
      t.integer :creator_id

      t.timestamps
    end
  end
end