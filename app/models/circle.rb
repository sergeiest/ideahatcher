class Circle < ActiveRecord::Base
  attr_accessible :startup_id, :status, :user_id

  belongs_to :user
  belongs_to :startup

end
