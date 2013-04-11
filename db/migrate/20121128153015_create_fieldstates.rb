class CreateFieldstates < ActiveRecord::Migration
  def change
    create_table :fieldstates do |t|
      t.string  :field_status
      t.integer :allfield_id

      t.timestamps
    end
  end
end
