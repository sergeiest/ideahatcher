class Companyupdate < ActiveRecord::Base
  attr_accessible :content, :newsdate, :startup_id, :title
  belongs_to :Startup

  validates_length_of :title, :within => 3..40
  validates_length_of	:content, :within => 3..140

end
