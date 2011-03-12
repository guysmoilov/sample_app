# == Schema Information
# Schema version: 20110225140805
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  
  attr_accessible :name, :email

  validates :name,  :presence => true,
                    :length   => {:maximum => 50}
                    
  validates :email, :presence => true,
                    :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i},
                    :uniqueness => {:case_sensitive => false}
  
end
