# # Seed用のユーザーを作成
# user1 = User.create!(
#   email: "user1@example.com",
#   password: "password",
#   password_confirmation: "password",
# )

# user2 = User.create!(
#   email: "user2@example.com",
#   password: "password",
#   password_confirmation: "password",
# )

user3 = User.create!(
  name: "user3",
  email: "user3@example.com",
  password: "password",
  password_confirmation: "password",
)

# user1 = User.find_by(
#   email: "user1@example.com",
# )
# user2 = User.find_by(
#   email: "user2@example.com",
# )
  
  # # 関連映画のIDリスト（シードデータとして使用するTMDbの映画ID）
# related_movie_ids_user1 = [299536, 597] # サンプルのTMDb映画ID
# related_movie_ids_user2 = [680, 155]    # 別のサンプルのTMDb映画ID（例: 'Pulp Fiction', 'The Dark Knight'）

# # TMDBから映画データを取得
# tmdb_service = TmdbService.new
# movies_user1 = tmdb_service.fetch_movies(related_movie_ids_user1)
# movies_user2 = tmdb_service.fetch_movies(related_movie_ids_user2)

# # ViewContextのスタブを作成
# class ViewContextStub
#   include Rails.application.routes.url_helpers

#   def url_for(options)
#     "http://example.com/related_movies/#{options[:id]}"
#   end
# end

# view_context_stub = ViewContextStub.new

# # OverviewShufflerを使用してシャッフルされた概要を生成
# shuffled_overview_content_user1 = OverviewShuffler.shuffle_overview(movies_user1, view_context_stub)
# shuffled_overview_content_user2 = OverviewShuffler.shuffle_overview(movies_user2, view_context_stub)

# # ShuffledOverviewレコードを作成
# shuffled_overview1 = ShuffledOverview.create!(
#   content: shuffled_overview_content_user1,
#   user: user1,
#   related_movie_ids: related_movie_ids_user1
# )

# shuffled_overview2 = ShuffledOverview.create!(
#   content: shuffled_overview_content_user2,
#   user: user2,
#   related_movie_ids: related_movie_ids_user2
# )

# # ユーザー同士をフォローさせる
# user1.follow(user2)
# user2.follow(user1)

# # Followモデルがある場合、手動でレコードを作成する必要があるかもしれません
# # その場合、次のように手動でフォローレコードを作成します。
# Follow.create!(follower: user1, followed: user2)
# Follow.create!(follower: user2, followed: user1)
