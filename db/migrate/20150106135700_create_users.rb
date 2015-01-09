class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :primary_email
      t.string :first_name
      t.string :last_name
      t.string :password_hash

      t.timestamps
    end
  end
end