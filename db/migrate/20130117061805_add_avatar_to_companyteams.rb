class AddAvatarToCompanyteams < ActiveRecord::Migration
  def self.up
    add_attachment :companyteams, :avatar
  end

  def self.down
    remove_attachment :companyteams, :avatar
  end
end
