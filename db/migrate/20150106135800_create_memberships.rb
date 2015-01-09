class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string :member_email
      t.integer :user_id
      t.integer :community_id

      t.timestamps
    end
  end
end