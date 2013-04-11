class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer  :startup_id
      t.integer  :goal_sum
      t.integer  :raised_sum
      t.datetime :closing_date
      t.integer  :valuation_sum
      t.integer  :status
      t.float    :share

      t.timestamps
    end
  end
end
