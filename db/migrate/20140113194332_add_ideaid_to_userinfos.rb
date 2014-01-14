class AddIdeaidToUserinfos < ActiveRecord::Migration
  def change
  	add_column :userinfos, :idea_id, :integer
  end
end
