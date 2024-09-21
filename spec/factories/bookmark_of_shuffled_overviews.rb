FactoryBot.define do
  factory :bookmark_of_shuffled_overview do
    association :user
    association :shuffled_overview
  end
end
