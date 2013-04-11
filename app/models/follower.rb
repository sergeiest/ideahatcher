class Follower < ActiveRecord::Base
  attr_accessible :startup_id, :status, :user_id
  belongs_to :startup
  belongs_to :user

end
