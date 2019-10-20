FactoryBot.define do
  factory :comment_reply do
    body { Faker::Lorem.word }
  end
end
