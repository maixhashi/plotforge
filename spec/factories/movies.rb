FactoryBot.define do
  factory :movie do
    tmdb_id { Faker::Number.unique.number(digits: 4) } # 5桁のランダムな数字を生成
  end
end
