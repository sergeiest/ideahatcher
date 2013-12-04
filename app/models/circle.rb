class Circle < ActiveRecord::Base
  attr_accessible :startup_id, :status, :user_id

  belongs_to :user
  belongs_to :startup

  # status
  # 0 - share with everyone (user_id = 0)
  # 1 - manually selected
  # 2 - randomly selected
  # 3 - request access
  # 4 - access removed

end
