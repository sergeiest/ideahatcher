class AddAvatarToStartups < ActiveRecord::Migration
  def self.up
    add_attachment :startups, :avatar
  end

  def self.down
    remove_attachment :startups, :avatar
  end
end
