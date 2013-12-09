class Colleague < ActiveRecord::Base
  attr_accessible :fund_id, :user_id
  belongs_to :fund
  belongs_to :user


end
