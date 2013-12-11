class Allfield < ActiveRecord::Base
  attr_accessible :field_name, :view_flag
  has_many :companydescriptions
  has_many :fieldstates
end
