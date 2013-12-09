class AddEmailPrefToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :email_pref, :boolean, :default => true
  end
end
