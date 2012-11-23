require 'spec_helper'

describe "LayoutLinks" do

  it "should have a home page at /" do
    get '/'
    response.should have_selector("title", :content => "Home")
  end

  it "should have a contact page at /contact" do
    get '/contact'
    response.should have_selector("title", :content => "Contact")
  end

  it "should have an about page at /about" do
    get '/about'
    response.should have_selector("title", :content => "About")
  end

  it "should have a help page at /help" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  #note that this page is not in the pages controller, but in the users controller
  # this is an advantage of integration tests - they can access more than one ctrlr
  it "should have a signup page at /signup" do
    get '/signup'
    response.should have_selector('title', :content => "Sign Up")
  end

  #now we will test if hte links actually lead to the right pages
  it "should have the right links in teh layout" do
    visit root_path

    click_link "Contact"
    response.should have_selector("title", :content => "Contact")

    click_link "About"
    response.should have_selector("title", :content => "About")

    click_link "Home"
    response.should have_selector("title", :content => "Home")

    click_link "Sign up now!"
    response.should have_selector("title", :content => "Sign Up")
  end

end
