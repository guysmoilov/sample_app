require 'spec_helper'

describe User do
  
  before (:each) do
    @attr = {:name => "Sasi", :email => "sasi@hummus.com"}
  end
  
  it "should create a new instance given valid attributes" do
    User.create! @attr
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should limit name length to 50 chars" do
    long_name_user = User.new(@attr.merge(:name => 'a' * 51))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid emails" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.valid?
    end
  end
  
  it "should reject invalid emails" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
end
