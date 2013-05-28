class Notification < ActiveRecord::Base
  attr_accessible :event_id, :event_type, :status, :user_id

  belongs_to :User

end
