require "faker"

namespace :db do

  desc "Fill DB with smaple users"

  # define the task db:populate
  task :populate => :environment do

    #first call rake to reset the db
    Rake::Task['db:reset'].invoke
    User.create!(:name => "Example User",
                 :email => "example@railstutorial.org",
                 :password => "password",
                 :password_confirmation => "password")
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(:name => name,
                       :email => email,
                       :password => password,
                       :password_confirmation => password)

    end
  end

end