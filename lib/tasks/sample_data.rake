require 'date'
namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    today = Date.today.to_s
    admin = User.create!(:name => "admin",
                 :email => "admin@intown.com",
                 :address => "N/A",
                 :password => "Sagehens47",
                 :password_confirmation => "Sagehens47",
                 :prototype_key => "0b95372d68")
    admin.toggle!(:admin)
    radiohead = Company.create!(:contact_name => "Thom Yorke",
                 :email => "thom@radiohead.com",
                 :company_name => "Radiohead",
                 :password => "65a217fbe9",
                 :password_confirmation => "65a217fbe9",
                 :prototype_key => "0b95372d68")
    radiohead.events.create!(:date => today, :address => "61 Savitt Way, Hartford, CT")
    lilwayne = Company.create!(:contact_name => "Lil Wayne",
                 :email => "lilwayne@youngmoney.net",
                 :company_name => "Lil Wayne",
                 :password => "65a217fbe9",
                 :password_confirmation => "65a217fbe9",
                 :prototype_key => "0b95372d68")
    lilwayne.events.create!(:date => today, :address => "413 4th Avenue, Collins, IA 50055")
    mgs = Company.create!(:contact_name => "John Darnielle",
                 :email => "jd@mgs.net",
                 :company_name => "The Mountain Goats",
                 :password => "65a217fbe9",
                 :password_confirmation => "65a217fbe9",
                 :prototype_key => "0b95372d68")
    mgs.events.create!(:date => today, :address => "Claremont, CA 91711")
    ladygaga = Company.create!(:contact_name => "Lady Gaga",
                 :email => "lady@gaga.net",
                 :company_name => "Lady Gaga",
                 :password => "65a217fbe9",
                 :password_confirmation => "65a217fbe9",
                 :prototype_key => "0b95372d68")
    ladygaga.events.create!(:date => today, :address => "1260 Avenue of the Americas, New York, NY 10020")
    
=begin 
    5000.times do |n|
      name  = Faker::Name.name
      email = "#{name}#{rand(4000)}@gmail.com".gsub(/ /,'')
      lat = rand * (47.60620950-33.74899540) + 33.74899540
      long = -(rand * (71-122.33207080) + 122.33207080)
      password  = "password"
      puts name
      user = User.new(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
      user.latitude = lat
      user.longitude = long
      user.save(:validate => false)
      seed1 = rand(4) + 1
      seed2 = seed1
      until seed1 != seed2
        seed2 = rand(4) + 1
      end
      user.follow!(Company.find_by_id(seed1))
      user.follow!(Company.find_by_id(seed2))
    end
=end  
  
  
  end
end
