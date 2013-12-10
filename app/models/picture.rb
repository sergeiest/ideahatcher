class Picture < ActiveRecord::Base
  attr_accessible :description, :startup_id, :status, :title, :avatar

  belongs_to :startup

  has_attached_file :avatar, styles: {
      large: '300x300#',
      teaser: '120x120#',
      thumb: '30x30#',
  }

end
