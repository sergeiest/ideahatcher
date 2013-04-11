class Campaign < ActiveRecord::Base
  attr_accessible :closing_date, :goal_sum, :raised_sum, :startup_id, :status, :valuation_sum, :share

  validates_presence_of :goal_sum, :share, :message => "Incomplete fields"
  validate :validates_share_and_goal_sum
  #validate :test

  belongs_to :Startup

  def validates_share_and_goal_sum

    if share && goal_sum
      errors.add(:share, "You cannot offer more than 90% of the company") if share > 90
      errors.add(:share, "You should offer at least 0.5% of the company") if share < 0.5
      errors.add(:share, "Valuation is higher that $1 billion") if share != 0 and goal_sum/share * 100 > 1000000000
      errors.add(:goal_sum, "Goal should be more than $2,000")  if goal_sum < 2000
      errors.add(:goal_sum, "Goal should be less than $1 million")  if goal_sum > 1000000

      number_of_days = Date.parse(closing_date.strftime('%Y-%m-%d')) - Date.today
      errors.add(:closing_date, "The closing date should be within 2 months from today") if  number_of_days > 61
      errors.add(:closing_date, "The closing date should be a date in future")if Date.parse( closing_date.strftime('%Y-%m-%d')) < Date.today
    end
  end

  def self.check_errors(campaign_info)
    if campaign_info[:goal_sum] == nil || campaign_info[:goal_sum].to_i < 2000 || campaign_info[:goal_sum].to_i > 1000000
      return "goal_sum/Invalid campaign goal"
    end
    if campaign_info[:share] == nil || campaign_info[:share].to_i < 0.5 || campaign_info[:share].to_i > 90
      return "share/Invalid offered share"
    end
    if campaign_info[:closing_date] == nil
      return "closing_date/Invalid closing date"
    end
    if campaign_info[:goal_sum].to_i / campaign_info[:share].to_i * 100 > 1000000000
      return "valuation_sum/Invalid valuation"
    end
    nil
  end



end