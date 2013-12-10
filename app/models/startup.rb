class Startup < ActiveRecord::Base
  attr_accessible :name, :link, :pitch, :status, :avatar, :votes

  validates_length_of :name, :within => 3..40
  #validates_format_of :link, :with => /(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum|li|ru|io|co)/i, :message => "Invalid email"

  has_many :companyupdates
  has_many :companydescriptions
  has_many :ideas
  has_many :tags

  has_many :investors
  has_many :owners
  has_many :followers
  has_many :circles

  has_many :pictures, :dependent => :destroy

  has_many :investor_users, :through => :investors, :source => :user
  has_many :owner_users, :through => :owners, :source => :user
  has_many :follower_users, :through => :followers, :source => :user
  has_many :circle_users, :through => :circles, :source => :user
  has_many :investor_funds, :through => :investors, :source => :fund

  has_attached_file :avatar, styles: {
      large: '600x300#',
      teaser: '240x120#',
      thumb: '60x30#',

  }

  def self.check_errors(startup_info)
    if startup_info[:name] == nil || startup_info[:name] == "" || !startup_info[:name].length.between?(3, 40)
      return "name/Invalid company name"
    end
    if startup_info[:link] != "" and !startup_info[:link] =~ /(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum|li|ru|io|co)/i
      return "link/Invalid website link"
    end
    nil
  end

end

