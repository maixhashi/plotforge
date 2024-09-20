FactoryBot.define do
  factory :bookmark_of_movie do
    association :user
    association :movie
  end
end
