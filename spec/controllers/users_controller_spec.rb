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
    end

    it "should have the user name as title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name)
    end

    it "should include the user name as header" do
      get :show, :id => @user
      response.should have_selector('h1', :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      # the > syntax means, the img selector should be inside the h1 selector
      # making the tests that specific/coupled might be problematic
      response.should have_selector('h1>img', :class => "gravatar")
    end

  end

  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign Up")
    end
  end


  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = {
            :name => "", :email => "", :password => "", :password_confirmation => ""
        }
      end

      it "should not create a user" do

        #TODO : what does this do?
        lambda do
          post :create, :user => @attr
          # the rspec 'change' method returns the number of saved entities in the database
          # this happens by calling the 'count' method of ActiveRecord
        end.should_not change(User, :count)
      end
      it "should have the right tile" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign Up")
      end
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template(:new)
      end

    end


    describe "success" do

      before(:each) do
        @attr = {
            :name => "Duckface", :email => "duck@face.com", :password => "secret", :password_confirmation => "secret"
        }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      it "should redirect to the user show page" do
        post :create, :user => @attr
        # in the controller we use @user, which is translated to user_path by rails. RSpec can't so that, so here we use user_path
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "shoud have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome /i
        #response.should have_selector(:success, :content => "Welcome") - doesnt work - the response is a redirect
      end

    end

  end

end
