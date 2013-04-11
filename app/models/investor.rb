class Investor < ActiveRecord::Base
  attr_accessible :user_id, :startup_id, :sum
  validates_presence_of :sum, :message => "Incomplete fields"
  validate :validates_investment_amount
  belongs_to :startup
  belongs_to :user


  def validates_investment_amount

    if sum

      errors.add(:sum, "Investment should be between $25 and $2000") if sum < 25
      errors.add(:sum, "Investment should be between $25 and $2000") if sum > 2000

  end

  end

end
