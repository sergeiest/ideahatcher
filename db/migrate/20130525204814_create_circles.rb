class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.integer :startup_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
