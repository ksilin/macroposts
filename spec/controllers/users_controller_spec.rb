require 'spec_helper'

describe UsersController do

  #if not called, the specs call the ctrlr actions, but do not render the views
  # it's a trade-off between execution speed and missing some errors in the views
  render_views


  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  it "should have the right title" do
    get 'new'
    response.should have_selector('title', :content => "Sign Up")

  end

end
