class Vote < ActiveRecord::Base
  attr_accessible :companydescription_id, :score, :user_id, :startup_id
  belongs_to :Companydescription
end
