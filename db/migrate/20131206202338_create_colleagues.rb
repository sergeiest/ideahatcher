class CreateColleagues < ActiveRecord::Migration
  def change
    create_table :colleagues do |t|
      t.integer :user_id
      t.integer :fund_id

      t.timestamps
    end
  end
end
