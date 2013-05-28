class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :status
      t.integer :event_type
      t.integer :event_id

      t.timestamps
    end
  end
end
