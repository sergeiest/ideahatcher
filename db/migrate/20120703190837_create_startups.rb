class CreateStartups < ActiveRecord::Migration
  def change
    create_table :startups do |t|

      t.string   :link
      t.string   :name
      t.text     :pitch
      t.integer  :status
      t.string   :avatar
      t.integer  :status
      t.integer  :votes

	    t.timestamps
    end

  end
end
