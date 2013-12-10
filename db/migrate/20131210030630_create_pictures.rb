class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :startup_id
      t.text :description
      t.string :title
      t.integer :status

      t.timestamps
    end
  end
end
