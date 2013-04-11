require 'digest/sha1'

class Authentication < ActiveRecord::Base

  validates_confirmation_of	:password
  validates_length_of :username, :within => 3..60
  validates_uniqueness_of :username

  validates_length_of	:password, :within => 3..40
  validates_uniqueness_of :username
  validates_format_of :username, :with => /[a-z0-9!\#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!\#$%\&'\*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum|li|ru|io|co)/i, :message => "Invalid email"

  attr_accessible :password, :status, :username, :salt
  has_one :User
  attr_protected :salt

  def make_username(username)
    self.username = username.gsub(/\s+/, "").downcase
  end

  def self.authenticate(authentication_info)
    auth = find(:first, :conditions=>["username = ?", authentication_info[:username].downcase])

    return nil if auth.nil?
    return auth if Authentication.encrypt(authentication_info[:password], auth.salt)==auth.password
    nil
  end

  def self.check_errors(authentication_info)
    if authentication_info[:username] == nil
      return "username/Please enter an email address"

    elsif  !authentication_info[:username] =~ /[a-z0-9!\#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!\#$%\&'\*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum|li|ru|io|co)/i
      return "username/You entered invalid email address"

    else

      if !authentication_info[:username].length.between?(3, 60)
        return "username/User name should be between 3 - 60 characters"

      elsif !authentication_info[:password].length.between?(3, 20)
        return "password/Password should be between 3 - 20 characters"
      else
        auth = find(:first, :conditions=>["username = ?", authentication_info[:username]])
        if auth != nil
          return "username/This username already exists"
        end
      end
    end
    nil
  end

    def make_hash(pass)
      @pwd=pass
      self.salt = Authentication.random_string(10)
      self.password = Authentication.encrypt(@pwd, self.salt)
    end

    def self.random_string(len)
      #generate a random password consisting of strings and digits
      chars = ("a" .. "z"). to_a + ("A" .. "Z"). to_a + ("0" .. "9"). to_a
      newpass = ""
      1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
      return newpass
    end

    def self.encrypt(pass, salt)
      Digest::SHA1.hexdigest (pass + salt)
    end

  end
