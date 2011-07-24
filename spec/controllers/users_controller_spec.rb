require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'new'" do
    
    before(:each) do
      get :new
    end
    
    it "should be successful" do
      response.should be_success
    end
    
    it "should have Sign Up in the title" do
      response.should have_selector("title", :content => "Sign Up")
    end
    
  end
  
  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
      get :show, :id => @user
    end
    
    it "should be successful" do
      response.should be_success
    end
    
    it "should get the right user from the database" do
      assigns(:user).should == @user
    end
    
    it "should have the user name in the title" do
      response.should have_selector("title", :content => @user.name)
    end
    
  end

end
