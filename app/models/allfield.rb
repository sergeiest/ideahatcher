class Allfield < ActiveRecord::Base
  attr_accessible :field_name, :view_flag
  has_many :Companydescriptions
  has_many :Fieldstates
end
