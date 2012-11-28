# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'spec_helper'

describe User do

  before :each do
    @attr = {:name => "me", :email => "me@me.so", :password => "secret", :password_confirmation => "secret"}
  end

  it "should create a new instance given valid attributes" do
    # create! works just like create but raises an RecordInvalid exception on failure
    User.create!(@attr)
  end

  it "should require a name" do
    no_name = User.create(@attr.merge({:name => ""}))
    # rspec allows the use of any boolean method like *be_valid* instead of *valid?*
    # the recipe: drop the question mark and prepend a 'be_'
    # equiv: no_name.valid?.should_not == true
    no_name.should_not be_valid
  end

  it "should require an email" do
    no_email = User.create(@attr.merge({:email => ""}))
    no_email.should_not be_valid
  end

  it "should reject too long names" do
    name_too_long = User.create(@attr.merge({:name => 'a'* 51}))
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

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "should require a password" do
      user = User.create(@attr.merge(:password => ""))
      user.should_not be_valid
    end
    it "should require a matching password confirmation" do
      user = User.create(@attr.merge(:password => ""))
      user.should_not be_valid
    end
    it "should reject short passwords" do
      user = User.create(@attr.merge({:password => "aaa", :password_confirmation => "aaa"}))
      user.should_not be_valid
    end
    it "should reject long passwords" do
      user = User.create(@attr.merge({:password => "a"*41, :password_confirmation => "a"*41}))
      user.should_not be_valid
    end
  end

  describe "password encryption" do

    before :each do
      @user = User.create(@attr)
    end

    it "should have an encrypted password" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be tre if passowrds match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords dont match" do
        @user.has_password?(@attr["wrong"]).should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on password mismatch" do
        user_authenticate = User.authenticate(@attr[:email], "wfawef")
        user_authenticate.should be_nil
      end
      it "should return nil for email with no user" do
        user_authenticate = User.authenticate("somefakeemeail", @attr[:password])
        user_authenticate.should be_nil
      end
      it "should return the user on emal and password match" do
        user_authenticate = User.authenticate(@attr[:email], @attr[:password])
        user_authenticate.should == @user
      end
    end
  end
end
