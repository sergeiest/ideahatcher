class User < ActiveRecord::Base

  attr_accessible :firstname, :lastname, :description, :authentication_id, :avatar

  validates_presence_of :firstname, :lastname,  :message => "Incomplete fields"


  has_many :Investors
  has_many :Owners
  has_many :Followers
  has_many :Circles
  has_many :Notifications
  
  has_many :Investor_startups, :through => :Investors, :source => :startup
  has_many :Owner_startups, :through => :Owners, :source => :startup
  has_many :Follower_startups, :through => :Followers, :source => :startup
  has_many :Circle_startups, :through => :Circles, :source => :startup

  has_many :Funds
  has_many :Ideas

  attr_protected :authentication_id
  belongs_to :Authentication

  has_attached_file :avatar, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
  }


  def self.check_errors(user_info)

    if user_info[:firstname] == nil || user_info[:firstname] == ""
      return "firstname/Invalid First Name"
    end
    if user_info[:lastname] == nil || user_info[:lastname] == ""
      return "lastname/Invalid Last Name"
    end
    nil
  end

end
