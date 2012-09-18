namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "root User",
                 email: "u1@u.com",
                 password: "123456",
                 password_confirmation: "123456")
    u = User.first
    u.level = 0
    u.password = u.password_confirmation = "123456"
    u.save

    15.times do |n|
      name  = Faker::Name.name
      email = "u#{ n + 2 }@u.com"
      password  = "123456"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end