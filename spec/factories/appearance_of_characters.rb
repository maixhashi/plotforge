FactoryBot.define do
  factory :appearance_of_character do
    association :character
    association :shuffled_overview
  end
end
