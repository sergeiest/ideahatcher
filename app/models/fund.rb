class Fund < ActiveRecord::Base

  attr_accessible :name, :hashtag, :status

  has_many :colleagues, :dependent => :destroy
  has_many :users, :through => :colleagues

end
