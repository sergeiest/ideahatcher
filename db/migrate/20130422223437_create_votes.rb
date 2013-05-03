class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :companydescription_id
      t.integer :user_id
      t.integer :score

      t.timestamps
    end
  end
end
