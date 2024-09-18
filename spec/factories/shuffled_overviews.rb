FactoryBot.define do
  factory :shuffled_overview do
    content { "This is a sample shuffled overview content." }
    user # userファクトリとの関連を自動で設定します
    related_movie_ids { [12345, 67890] } # 適当なTMDBのmovie IDを配列で設定
    related_movie_genres { ['Action', 'Drama'] } # 適当なジャンルの配列を設定
    created_at { Time.now }
    updated_at { Time.now }
  end
end
