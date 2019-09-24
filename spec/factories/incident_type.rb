FactoryBot.define do
  factory :incident_type do
    title { Faker::Lorem.sentence(40) }
  end
end
