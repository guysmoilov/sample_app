# == Schema Information
# Schema version: 20110225140805
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  email                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  encrypted_password   :string (SHA1)
#  salt                 :string (SHA1)

require 'digest'

class User < ActiveRecord::Base
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  validates :name,
    :presence => true,
    :length   => {:maximum => 50}

  validates :email,
    :presence => true,
    :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i},
    :uniqueness => {:case_sensitive => false}

  validates :password,
    :length => {:in => 6..40},
    :confirmation => true,
    :presence => true
  
  before_save :encrypt_password
  
  # Static method for identifying users by email and password,
  # returns the user if successful, nil if no user found or pass doesn't match.
  def User.authenticate (submitted_email, submitted_password)
    
    # Check if user exists
    user = User.find_by_email(submitted_email)
    
    return nil if user.nil?
    return user if user.compare_pass(submitted_password)
    
  end
  
  # Compare given password to encrypted one in DB
  def compare_pass (pass)
    return self.encrypted_password == sha_hash("#{pass}--#{self.salt}")
  end
  
  protected
    
    # Create the encrypted password to be saved in DB
    def encrypt_password
      
      # If the user is new, create a salt
      self.make_salt if new_record?
      
      # Hash the salt and password to create the encrypted pass
      self.encrypted_password = sha_hash("#{self.password}--#{self.salt}")
      
    end
    
    # Create a salt from current time and hash
    def make_salt
      self.salt = sha_hash(Time.now.to_s)
    end
    
    # Return a SHA encryption of the argument
    def sha_hash (arg)
      Digest::SHA1.hexdigest(arg)
    end

end
