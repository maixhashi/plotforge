FactoryBot.define do
  factory :shuffled_overview do
    content { "This is a sample shuffled overview content." }
    user
    related_movie_ids { [12345, 67890] }
    related_movie_genres { ['Action', 'Drama'] }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
