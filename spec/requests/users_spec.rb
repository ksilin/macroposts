require 'spec_helper'

describe "Users" do

  describe "Signup" do

    describe "failure" do

      it "should not make a new user" do

        lambda do
          visit signup_path

          # actually, shouldn't the form be empty, why bother filling in nothing?
          fill_in "Name", :with => ""

          click_button
          #you can also use :use_name - the id of the according text field. Good when there are no labels
          response.should render_template('users/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "should make a new user" do

        lambda do
          visit signup_path

          fill_in "Name", :with => "New User"
          fill_in "Email", :with => "user@example.com"
          fill_in "Password", :with => "1234567"
          fill_in "Confirmation", :with => "1234567"

          click_button
          #you can also use :user_name - the id of the according text field. The naming scheme is resource_property Good when there are no labels
          response.should render_template('users/show')
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in and out" do

    describe "success" do

      it "should sign a user in and out" do
        integration_sign_in(FactoryGirl.create(:user))
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end

    describe "failure" do

      it "should not sign a user in" do
        visit signin_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end
  end
end
