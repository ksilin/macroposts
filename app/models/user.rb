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

require 'digest'
class User < ActiveRecord::Base

  # once attr_accessible has been defined, only the ones listed are updateable over update_attributes
  attr_accessible :email, :name, :password, :password_confirmation

  # this creates a virtual attribute for holding the password
  attr_accessor :password

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i


  # :presence => true is a one-values hash. curly braces are optional of the hash is hte last arg.
  validates :name, :presence => true, :length => {:maximum => 50}
  # funny, but validates :uniqueness does not guarantee uniqueness - the validation happens in mem,
  # so two users with same email would be valid in mem, and then both would be saved to the DB
  # so we have to enforce uniqueness in the DB with a uniqueness index
  validates :email, :presence => true, :format => {:with => email_regex}, :uniqueness => {:case_sensitive => false}
  # can also be written as validates(:name, {:presence => true})

  # :confirmation => true automatically creates a password_confirmation attribute
  validates :password, :presence => true, :confirmation => true, :length => {:within => 6..40}

  # TODO: what was the difference again between using the self and the @ here
  def self.authenticate(email, submitted_password)

    # omitting the User. before he find_by_email method
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password? submitted_password
    # omitting the else here, handling the case when the password didnt match
    # int this case, the end of the method would have been reached, automatically returning nil
    # simply putting nil in the last line would work identically
  end

  # class methods are defined using the self. or the
  # class << self block, where all methods are class methods

  # hte API for querying the passwords
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  # defining an ActiveRecord callback
  before_save :encrypt_password

  private
  def encrypt_password
    self.salt = make_salt if new_record?
    # why is the password not a symbol?
    # because it's identical to self.password where self is optional
    # self is not optional when assigning - without sef, a local var would be created
    self.encrypted_password = encrypt(password)
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end
