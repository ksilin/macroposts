class AddEmailUniquenessIndex < ActiveRecord::Migration

  #indexing will take care of the uniqueness issue and will make search by email more efficient
  def self.up
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :users, :email
  end
end
