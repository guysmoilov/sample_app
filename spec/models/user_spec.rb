require 'spec_helper'

describe User do
  
  before (:each) do
    @attr = {
              :name => "Sasi",
              :email => "sasi@hummus.com",
              :password => "foobar",
              :password_confirmation => "foobar"
            }
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
  
  it "should reject users with identical emails" do
    User.create!(@attr)
    duplicate_email_user = User.new(@attr.merge(:name => "uzi"))
    duplicate_email_user.should_not be_valid
  end
  
  it "should reject duplicate emails regardless of case" do
    User.create!(@attr)
    duplicate_email_user = User.new(@attr.merge(:name => "uzi", :email => @attr[:email].upcase))
    duplicate_email_user.should_not be_valid
  end
  
  describe "password validations" do
  
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
    end
    
    it "should require a minimal password length" do
      short = "a" * 5
      User.new(@attr.merge(:password => short, :password_confirmation => short)).
      should_not be_valid
    end
    
    it "should limit password length" do
      long = 'a' * 41
      User.new(@attr.merge(:password => long, :password_confirmation => long)).
      should_not be_valid
    end
  
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "bogu")).
      should_not be_valid
    end
  
  end
  
  describe "password encryption" do
    
    before (:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "compare_pass method" do
      
      it "should be true if the passwords match" do
        @user.compare_pass(@attr[:password]).should be_true
      end
      
      it "should be false if the passwords don't match" do
        @user.compare_pass("WRONG").should be_false
      end
      
    end
    
  end
  
  describe "authentication" do
    
    before (:each) do
      @user = User.create!(@attr)
    end
    
    it "should authenticate with valid email and matching password" do
      auth_user = User.authenticate(@attr[:email], @attr[:password])
      auth_user.should == @user
    end
    
    it "should return nil if email doesn't exist" do
      User.authenticate("WRONG@no.com", @attr[:password]).should be_nil
    end
    
    it "should return nil if password doesn't match" do
      User.authenticate(@attr[:email], "WRONGPASS").should be_nil
    end
    
  end
  
end
