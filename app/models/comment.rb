class Comment < ActiveRecord::Base
  attr_accessible :idea_id, :status, :user_id

  belongs_to :user
end
