class CreateInvestors < ActiveRecord::Migration
  def change
    create_table :investors do |t|
      t.integer  :fund_id
      t.integer  :user_id
      t.integer  :startup_id
      t.integer  :status
      t.integer  :connection_type


      t.timestamps
    end
  end
end
