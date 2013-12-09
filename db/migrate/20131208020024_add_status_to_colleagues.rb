class AddStatusToColleagues < ActiveRecord::Migration
  def change
  	  	add_column :colleagues, :status, :integer
  end
end
