class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.string :name
      t.string :hashtag
      t.integer :status

      t.timestamps
    end
  end
end
