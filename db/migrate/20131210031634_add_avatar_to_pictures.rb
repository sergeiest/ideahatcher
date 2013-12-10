class AddAvatarToPictures < ActiveRecord::Migration
  def self.up
    add_attachment :pictures, :avatar
  end

  def self.down
    remove_attachment :pictures, :avatar
  end
end
