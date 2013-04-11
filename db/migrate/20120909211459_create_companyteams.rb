class CreateCompanyteams < ActiveRecord::Migration
  def change
    create_table :companyteams do |t|
      t.integer  :startup_id
      t.string   :firstname
      t.string   :lastname
      t.string   :title
      t.text     :description
      t.string   :linkedin
      t.string   :cmuaffiliation
      t.string   :email
      t.string   :phone
      t.string   :address
      t.integer  :picture_id
      t.string   :avatar

      t.timestamps
    end
  end
end
