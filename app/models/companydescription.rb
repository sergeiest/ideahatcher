class Companydescription < ActiveRecord::Base
  attr_accessible :startup_id, :allfield_id, :content, :field_status, :approval_status, :companydescription_id,
                  :status
  #validates_uniqueness_of :allfield_id, :scope => :startup_id
  belongs_to :startup
  belongs_to :allfield
  has_many :votes
  has_many :ideas

end
