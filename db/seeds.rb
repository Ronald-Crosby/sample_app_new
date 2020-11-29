# Create a main sample user
User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now
            )

# Create 99 sample users
99.times do |n|
   name = Faker::Name.name
   email = "example-#{n+1}@railstutorial.org"
   password = "password"
   User.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end

# Create 50 posts for the first 6 users
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# create following relationships for users
users = User.all
our_user = users.first
# the users our user is following
following = users[2...50]
# our users followers
followers = users[5...20]

following.each { |poster| our_user.follow(poster) }
followers.each { |poster| poster.follow(our_user) }