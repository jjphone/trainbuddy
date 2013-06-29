namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "root User",
                 email: "u1@u.com",
                 login: "root.user",
                 phone: "12345678",
                 password: "123456",
                 password_confirmation: "123456")
    u = User.first
    u.profile.settings.level = 0
    u.password = u.password_confirmation = "123456"
    u.save!
    make_users
    make_microposts
    make_relationships


  end

  def make_users
    50.times do |n|
      name = Faker::Name.name
      email = "u#{n+2}@u.com"
      password = "123456"
      phone = (5000000+n).to_s
      login = "tester.#{n+2}"
      User.create!(name: name, email: email, phone: phone, login: login,
          password: password, password_confirmation: password )
    end
  end

  def make_microposts
    users = User.all(limit: 10)
    5.times do
      content = Faker::Lorem.sentence(5)
      users.each { |u| u.microposts.create!(content: content) }
    end
  end

  def make_relationships
    make_users if User.count < 50
    users = User.all
    owner = users.first
    friends = users[1..15]
    requests = users[16..25]
    pendings = users[26..35]
    blocked = users[36..40]
    been_blocked = users[41..45]

    friends.each { |f| Relationship.create!(status: 3, user_id: owner.id, friend_id: f.id ) 
      Relationship.create!(status: 3, user_id: f.id, friend_id: owner.id ) 
    }
    requests.each { |r| Relationship.request(r.id, owner.id) }
    pendings.each { |p| Relationship.request(owner.id, p.id) }
    blocked.each  { |b| Relationship.block(owner.id, b.id)}

    been_blocked.each  { |b|
      Relationship.create!(status:3, user_id: owner.id, friend_id: b.id)
      Relationship.block(b.id, owner.id)
    }
    other = users[2]
    other_friends = users[3..20] 
    other_friends.each { |f|  Relationship.create!(status: 3, user_id: other.id, friend_id: f.id)
                              Relationship.create!(status: 3, user_id: f.id, friend_id: other.id) }

  end

end