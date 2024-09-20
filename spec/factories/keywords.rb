FactoryBot.define do
  factory :keyword do
    content { Faker::Lorem.unique.word } # Fakerを使ってランダムな単語を生成
  end
end
