FactoryBot.define do
  factory :character do
    name { Faker::Name.name }
  end
end
