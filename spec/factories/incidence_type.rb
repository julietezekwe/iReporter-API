FactoryBot.define do
  factory :incidence_type do
    title { Faker::Lorem.sentence(40) }
  end
end
