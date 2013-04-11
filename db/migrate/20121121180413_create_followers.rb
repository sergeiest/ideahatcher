class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.integer  :startup_id
      t.integer  :user_id
      t.integer  :status

      t.timestamps
    end
  end
end
