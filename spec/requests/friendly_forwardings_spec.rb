require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = FactoryGirl.create(:user)
    # user is not logged in here
    visit edit_user_path(user)
    # here we should be redirected to signin page - so why cannot we test for a redirect?
    # beacause integration tests *follow* redirects - p.382
   # response.should redirect_to(signin_path)
     p response
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
    response.should render_template("users/edit")

  end
end
