class Investor < ActiveRecord::Base

  attr_accessible :user_id, :startup_id, :fund_id, :status, :connection_type

  belongs_to :fund
  belongs_to :user
  belongs_to :startup

end
