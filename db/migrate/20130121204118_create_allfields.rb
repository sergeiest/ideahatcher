class CreateAllfields < ActiveRecord::Migration
  def change

    create_table :allfields do |t|
      t.string   :field_name
      t.integer  :view_flag

      t.timestamps
    end
  end
end
