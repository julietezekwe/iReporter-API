FactoryBot.define do
  factory :incident do
    title { Faker::Lorem.word }
    evidence { Faker::Internet.url }
    narration { Faker::Lorem.word }
    location { Faker::Lorem.word }
    status { "draft" }
  end
end
