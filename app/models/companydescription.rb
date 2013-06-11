class Companydescription < ActiveRecord::Base
  attr_accessible :startup_id, :allfield_id, :content, :field_status, :approval_status, :companydescription_id,
                  :status
  #validates_uniqueness_of :allfield_id, :scope => :startup_id
  belongs_to :Startup
  belongs_to :Allfield
  has_many :Votes
  has_many :Ideas

end
