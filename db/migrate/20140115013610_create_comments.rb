class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :idea_id
      t.integer :status

      t.timestamps
    end
  end
end
