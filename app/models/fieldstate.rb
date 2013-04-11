class Fieldstate < ActiveRecord::Base
  attr_accessible :allfield_id, :field_status

  belongs_to :Allfield
end
