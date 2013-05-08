class Owner < ActiveRecord::Base
  attr_accessible :startup_id, :status, :user_id, :role

  belongs_to :user
  belongs_to :startup

end
