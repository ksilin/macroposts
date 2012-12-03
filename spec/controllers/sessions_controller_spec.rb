require 'spec_helper'

describe SessionsController do

  render_views

  describe "GET 'new'" do

    it "returns http success" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector(:title, :content => "Sign in")
    end
  end

  describe "POST create" do

    describe "failure" do

      before(:each) do
        @attrs = {:email => "user@email.com", :password => "1234567"}
      end

      it "should have the right title" do
        post :create, :session => @attrs
        response.should have_selector(:title, :content => "Sign in")
      end

      it "should have a flash.now message" do
        post :create, :session => @attrs
        flash.now[:error].should=~ /Invalid/i
      end
      it "should redisplay the new page" do
        post :create, :session => @attrs
        response.should render_template(:new)
      end

    end

    describe "success" do

      before(:each) do
        @user = FactoryGirl.create(:user)
        @attrs = {:email => @user.email, :password => @user.password}
      end

      it "should sign the user in" do
        post :create, :session => @attrs
        # controller is an implicit variable provided by rails
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      it "should redirect to the user show page" do
        post :create, :session => @attrs
        response.should redirect_to(user_path(@user))
      end

    end

  end

  describe "DELETE destroy" do

    it "will log the user out" do
      test_sign_in(FactoryGirl.create(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end

  end

end
