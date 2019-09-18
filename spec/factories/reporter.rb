FactoryBot.define do
  factory :reporter do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { Faker::Lorem.word }
    phone { Faker::PhoneNumber.phone_number }
    location { Faker::Lorem.sentence(40) }
    bio { Faker::Lorem.sentence(120) }
    avatar { Faker::Internet.url }
  end
end
