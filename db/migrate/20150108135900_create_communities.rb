class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :domain_part
      t.string :display_name

      t.timestamps
    end
  end
end