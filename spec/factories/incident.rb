FactoryBot.define do
  factory :incident do
    title { Faker::Lorem.sentence(40) }
    evidence { Faker::Internet.url }
    narration { Faker::Lorem.sentence(200) }
    location { Faker::Internet.sentence(40) }
    reporter_id 
    incident_type_id
  end
end
