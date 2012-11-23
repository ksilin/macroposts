class User < ActiveRecord::Base

  # once attr_accessible has been defined, only the ones listed are updateable over update_attributes
  attr_accessible :email, :name

  validates :name, :presence => true
end
