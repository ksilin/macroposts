class User < ActiveRecord::Base

  # once attr_accessible has been defined, only the ones listed are updateable over update_attributes
  attr_accessible :email, :name

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # :presence => true is a one-values hash. curly braces are optional of the hash is hte last arg.
  validates :name, :presence => true, :length => {:maximum => 50}
  validates :email, :presence => true, :format => {:with => email_regex}, :uniqueness => true
  # can also be written as validates(:name, {:presence => true})
end
