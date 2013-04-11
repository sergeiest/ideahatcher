class Companyteam < ActiveRecord::Base
  attr_accessible :address, :cmuaffiliation, :description, :email, :firstname, :lastname, :linkedin, :phone,:startup_id, :title, :avatar

  belongs_to :Startup

  has_attached_file :avatar, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
  }

end
