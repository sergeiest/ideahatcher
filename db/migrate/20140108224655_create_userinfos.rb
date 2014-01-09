class CreateUserinfos < ActiveRecord::Migration
  def change
    create_table :userinfos do |t|
      t.integer :user_id
      t.text :content
      t.integer :is_main
      t.integer :status
      t.string :category_type

      t.timestamps
    end
  end
end