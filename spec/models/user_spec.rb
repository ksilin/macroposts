require 'spec_helper'

describe User do

  before :each do
    @attr = {:name => "me", :email => "me@me.so"}
  end

  it "should create a new instance given valid attributes" do
    # create! works just like create but raises an RecordInvalid exception on failure
     User.create!(@attr)
  end

    it "should require a name"  do
      no_name = User.create(@attr.merge({:name =>""}))
      # rspec allows the use of any boolean method like *be_valid* instead of *valid?*
      # the recipe: drop the question mark and prepend a 'be_'
      # equiv: no_name.valid?.should_not == true
      no_name.should_not be_valid
    end

  it "should require an email"  do
    no_email = User.create(@attr.merge({:email =>""}))
    no_email.should_not be_valid
  end

  it "should reject too long names" do
    name_too_long = User.create(@attr.merge({:name=>'a'* 51}))
    name_too_long.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[use@foo.com SO.ME@thing.co.uk more.of.the@same.org]
    addresses.each do |address|
      valid_email = User.create(@attr.merge({:email => address}))
      p address
      valid_email.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[use@foo,com SO_ME.thing.co.uk more.of.the@same. more.of.the@@same.org]
    addresses.each do |address|
      valid_email = User.create(@attr.merge({:email => address}))
      valid_email.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    dupe = User.new(@attr)
    dupe.should_not be_valid
  end

end
