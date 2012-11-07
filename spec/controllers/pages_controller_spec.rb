require 'spec_helper'

# for each test, the complete rails environment is built up.
# If you prefer starting up the environment once (but may experience errors because of failing autoupdate))
# use Spork
describe PagesController do

  #if not called, the specs call the ctrlr actions, but do not render the views
  # it's a trade-off between execution speed and missing some errors in the views
  render_views

  before(:each) do
     @title_base = "Ruby on Rails Tutorial Sample App |"
  end

  describe "GET 'home'" do
    it "returns http success" do
      p "attempting to get home page"
      get 'home'
      response.should be_success
    end

    #for this test to run properly, render_view must be used (see above))
    it "has the right tile" do
      get 'home'
      # partial content is enough for have_selector to match
      response.should have_selector("title", :content => @title_base + " Home")
    end

  end

  describe "GET 'contact'" do
    it "returns http success" do
      p "attempting to get success page"
      get 'contact'
      response.should be_success
    end

    it "has the right tile" do
      get 'contact'
      # partial content is enough for have_selector to match
      response.should have_selector("title", :content => @title_base + " Contact")
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      p "attempting to get about page"
      get 'about'
      response.should be_success
    end

    it "has the right tile" do
      get 'about'
      # partial content is enough for have_selector to match
      response.should have_selector("title", :content => @title_base + " About")
    end
  end

  describe "GET 'help'" do
    it "returns http success" do
      p "attempting to get help page"
      get 'help'
      response.should be_success
    end

    it "has the right tile" do
      get 'help'
      # partial content is enough for have_selector to match
      response.should have_selector("title", :content => @title_base + " Help")
    end
  end
  
end
