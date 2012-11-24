class User < ActiveRecord::Base

  # once attr_accessible has been defined, only the ones listed are updateable over update_attributes
  attr_accessible :email, :name

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # :presence => true is a one-values hash. curly braces are optional of the hash is hte last arg.
  validates :name, :presence => true, :length => {:maximum => 50}
  # funny, but validates :uniqueness does not guarantee uniqueness - the validation happens in mem,
  # so two users with same email would be valid in mem, and then both would be saved to the DB
  # so we have to enforce uniqueness in the DB with a uniqueness index
  validates :email, :presence => true, :format => {:with => email_regex}, :uniqueness => {:case_sensitive => false}
  # can also be written as validates(:name, {:presence => true})
end
