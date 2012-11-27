require 'spec_helper'

describe UsersController do

  #if not called, the specs call the ctrlr actions, but do not render the views
  # it's a trade-off between execution speed and missing some errors in the views
  render_views

  describe "GET 'show'" do

    before(:each) do
      # test will fail if the @user is not created here
      @user = FactoryGirl.create(:user)

      # here, instead of using assigns in the test, we can use stubbing
      # calls to User.find with this given id will be intercepted and return our test user
      # some devs prefer stubbing, as it separates the controller tests from the model
      # User.stub!(:find, @user.id).and_return(@user)
    end

    it "should start with a valid user" do
      @user.should be_valid
    end
    it "should be successful" do

      # we could have used @user.id here, but since rails automatically converts the entity to it's id
      # by calling the 'to_param' method on it, we use the more succinct code
      get :show, :id => @user
      response.should be_success
    end
    it "should return the right user" do
      get :show, :id => @user
      #assigns takes a symbol and returns the controller instance var of teh same name
      assigns(:user).should == @user

      # instead of assigns we can use stubbing:

    end
  end


  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end
  end

  it "should have the right title" do
    get 'new'
    response.should have_selector('title', :content => "Sign Up")
  end

end
