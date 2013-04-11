class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :title
      t.text :content
      t.integer :startup_id
      t.integer :user_id
      t.integer :idea_id
      t.string :first_name
      t.string :last_name
      t.integer :is_protected

      t.timestamps
    end
  end
end
