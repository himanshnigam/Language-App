FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    body { Faker::Lorem.paragraph }
    association :user
    association :category
  end
end