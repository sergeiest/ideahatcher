class Notification < ActiveRecord::Base
  attr_accessible :event_id, :event_type, :status, :user_id

  belongs_to :user

  # event_type
  # 1 - add to the team
  # 2 - remove from the team
  # 3 - add access to idea
  # 4 - remove access to idea

end
