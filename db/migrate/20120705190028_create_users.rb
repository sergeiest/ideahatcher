class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string   :firstname
      t.string   :lastname
      t.string   :description
      t.integer  :authentication_id
      t.string   :avatar
      t.integer  :notification_num

      t.timestamps
    end
  end
end
