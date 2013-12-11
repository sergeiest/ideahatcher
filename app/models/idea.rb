class Idea < ActiveRecord::Base
  attr_accessible :content, :idea_id, :startup_id, :title, :user_id, :is_protected, :companydescription_id

  belongs_to :startup
  belongs_to :user
  belongs_to :companydescription

end
