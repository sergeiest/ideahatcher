class Fund < ActiveRecord::Base
  attr_accessible :fund_id, :user_id
  belongs_to :User
end
