require 'digest/sha1'

class Authentication < ActiveRecord::Base

  validates_confirmation_of	:password
  validates_length_of :username, :within => 3..60
  validates_uniqueness_of :username

  validates_length_of	:password, :within => 3..40
  validates_uniqueness_of :username
  validates_format_of :username, :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/i, :message => "Invalid email"

  attr_accessible :password, :status, :username, :salt
  has_one :user
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

    return "username/Please enter an email address" if authentication_info[:username] == nil

    if !authentication_info[:username].length.between?(3, 60)
      return "username/Email should be between 3 - 60 characters"
    end

    if authentication_info[:username] !~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/i
      return "username/Invalid Email Address"
    end

    if !authentication_info[:password].length.between?(3, 20)
        return "password/Password should be between 3 - 20 characters"
    end

    auth = find(:first, :conditions => ["username = ?", authentication_info[:username]])
    return "username/This email is already registered" if auth != nil

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
