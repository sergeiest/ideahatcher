class CreateCompanydescriptions < ActiveRecord::Migration
  def change
    create_table :companydescriptions do |t|
      t.integer  :startup_id
      t.text     :content
      t.integer  :allfield_id
      t.integer  :approval_status
      t.string   :field_status

      t.timestamps
    end
  end
end
