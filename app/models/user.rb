class User < ActiveRecord::Base

  attr_accessible :firstname, :lastname, :description, :authentication_id, :avatar

  validates_presence_of :firstname, :lastname,  :message => "Incomplete fields"

  has_many :colleagues, dependent: :destroy
  has_many :funds, :through => :colleagues
  has_many :investors
  has_many :owners
  has_many :followers
  has_many :circles
  has_many :notifications
  
  has_many :investor_startups, :through => :investors, :source => :startup
  has_many :owner_startups, :through => :owners, :source => :startup
  has_many :follower_startups, :through => :followers, :source => :startup
  has_many :circle_startups, :through => :circles, :source => :startup

  has_many :ideas
  has_many :userinfos
  has_many :comments

  attr_protected :authentication_id
  belongs_to :authentication

  has_attached_file :avatar, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
  }


  def self.check_errors(user_info)

    if user_info[:firstname] == nil || user_info[:firstname] == ""
      return "firstname/Please add you first name"
    end
    if user_info[:lastname] == nil || user_info[:lastname] == ""
      return "lastname/Please add you last name"
    end
    nil
  end

end
