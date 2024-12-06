FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password123' }
    username { Faker::Internet.username }
    language { User.languages.keys.sample }
  end
end