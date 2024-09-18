FactoryBot.define do
  factory :notification do
    visitor { association(:user) }
    visited { association(:user) }  # 通知の受信者を定義
    action { "bookmarked" }
    checked { false }
  end
end
