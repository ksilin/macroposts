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
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
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

      it "should sign the user in on signup" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should be a success" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should render the right template" do
      get :edit, :id => @user
      response.should render_template(:edit)
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector(:title, :content => "Edit user")
    end

    it "should have a link to change the gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      # TODO : how to match a href partially? - gravatar.com/emails does not match
      response.should have_selector(:a, :href => gravatar_url, :content => "change")
    end

  end

  describe "PUT 'update'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
        # @backup_user = @user# how to do a copy ctor - User.new(@user) seems not to be the right way -
        #NoMethodError: undefined method `stringify_keys' for #<User:0x00000002cd4608>
      end

      it "should return success" do
        put :update, :id => @user, :user => @attr
        response.should be_success
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector(:title, :content => "Edit user")
      end
      it "should render the edit page again" do
        put :update, :id => @user, :user => @attr
        response.should render_template(:edit)
      end
      #TODO: rather than checking for inequality, should check against an earlier version of the user

      it "should not change user data" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should_not == @attr[:name]
        @user.email.should_not == @attr[:email]
      end
    end

    describe "success" do

      before(:each) do
        @attr = {:name => "new name", :email => "new@example.com", :password => "newpassword", :password_confirmation => "newpassword"}
      end

      # checking for the right title or for the rendered template does not work here,
      # as on success we are redirected to the user show page
      it "should have flash success message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should_not be_blank
        flash[:success].should =~ /success/i
      end

      it "should render user profile" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should change user data" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.email.should == @attr[:email]
        @user.name.should == @attr[:name]
      end
    end
  end

  describe "authentication for edit/update pages" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-sgned-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      it "should deny access to 'update'" do
        get :update, :id => @user, :user => ()
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed in users" do

      before(:each) do
        wrong_user = FactoryGirl.create(:user, :email => "wrong@example.com")
        test_sign_in(wrong_user)
      end

      it "should require a matching user for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      it "should require a matching user for 'update'" do
        get :update, :id => @user
        response.should redirect_to(root_path)
      end

      # TODO :check happy path as well?
    end
  end

  describe "GET 'index'" do

    describe "for non-signed in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        second = test_sign_in(FactoryGirl.create(:user, :email => "second@example.com"))
        third = test_sign_in(FactoryGirl.create(:user, :email => "third@example.com"))
        @users = [@user, second, third]
      end

      it "should be successful" do
        get :index
        response.should be_success
      end
      it "should have the right title"  do
        get :index
        response.should have_selector(:title, :content => "All users")
      end
      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector(:li, :content => user.name)
        end
      end

    end

  end


end
