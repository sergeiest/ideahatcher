class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :companydescription_id
      t.integer :user_id
      t.integer :score
      t.integer :startup_id

      t.timestamps
    end
  end
end
