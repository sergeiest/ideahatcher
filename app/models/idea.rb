class Idea < ActiveRecord::Base
  attr_accessible :content, :idea_id, :startup_id, :title, :user_id, :is_protected, :companydescription_id

  belongs_to :Startup
  belongs_to :User
  belongs_to :companydescription

end
