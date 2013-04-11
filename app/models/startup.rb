class Startup < ActiveRecord::Base
  attr_accessible :name, :link, :pitch, :status, :avatar

  validates_length_of :name, :within => 3..40
  validates_format_of :link, :with => /(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum|li|ru|io|co)/i, :message => "Invalid email"

  has_many :Companyupdates
  has_many :Companydescriptions
  has_many :Companyteams
  has_many :Companydocuments
  has_many :Ideas

  has_many :Investors
  has_many :Owners
  has_many :Followers

  has_many :Investor_users, :through => :Investors, :source => :user
  has_many :Owner_users, :through => :Owners, :source => :user
  has_many :Follower_users, :through => :Followers, :source => :user

  has_one :Campaign

  has_attached_file :avatar, styles: {
      large: '600x300#',
      teaser: '240x120#',
      thumb: '60x30#',

  }

  def self.check_errors(startup_info)
    if startup_info[:name] == nil || startup_info[:name] == "" || !startup_info[:name].length.between?(3, 40)
      return "name/Invalid company name"
    end
    if !startup_info[:link] =~ /(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum|li|ru|io|co)/i
      return "link/Invalid website link"
    end
    nil
  end

end

