FactoryBot.define do
  factory :notification do
    association :visitor, factory: :user
    association :visited, factory: :user
    action { "bookmarked" }
    checked { false }

    trait :with_shuffled_overview do
      association :shuffled_overview
    end

    trait :with_movie do
      association :movie
    end
  end
end
