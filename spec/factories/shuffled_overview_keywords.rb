FactoryBot.define do
  factory :shuffled_overview_keyword do
    association :shuffled_overview
    association :keyword
  end
end
