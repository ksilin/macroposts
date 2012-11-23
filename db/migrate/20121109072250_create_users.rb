class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      #magic column generator - creates the automatically updated 'created_at' and 'updated_at' columns
      t.timestamps
    end
  end

  # what about the down method (and the up method?)
  # it seems to be obsolete - the rake db:rollback command works fine, dropping the table

end
