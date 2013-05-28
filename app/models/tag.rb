class Tag < ActiveRecord::Base
  attr_accessible :name, :startup_id

  belongs_to :startup
end
