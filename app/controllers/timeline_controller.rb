class TimelineController < ApplicationController
  before_action :set_user

  def index
    # 現在のユーザーとフォロワーのユーザーIDを取得
    user_ids = [current_user.id] + current_user.following.pluck(:id)

    # 取得したユーザーIDに基づいて、該当ユーザーのShuffledOverviewを取得
    @shuffled_overviews = ShuffledOverview.where(user_id: user_ids).order(created_at: :desc)

    # ジャンルフィルタリングの適用
    if params[:genre_id].present?
      genre_id = params[:genre_id].to_i
      @shuffled_overviews = @shuffled_overviews.select do |shuffled_overview|
        shuffled_overview.related_movie_ids.any? do |movie_id|
          movie_details = TmdbService.new.fetch_movie_details(movie_id)
          movie_details['genres'].any? { |genre| genre['id'] == genre_id }
        end
      end
    end

    # TMDBから映画の詳細情報を取得
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end

    # ページネーションの適用
    @shuffled_overviews_on_timeline = Kaminari.paginate_array(@shuffled_overviews).page(params[:shuffled_overviews_page]).per(5)

    # 全てのジャンルデータの取得
    @genres_data = {}
    all_genres = []
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        movie_details = tmdb_service.fetch_movie_details(movie_id)
        movie_details['genres'].each do |genre|
          all_genres << genre
        end
      end
    end

    # 重複を排除してジャンルデータを設定
    @genres_data = all_genres.uniq { |genre| genre['id'] }.map { |genre| [genre['id'], genre['name']] }.to_h
  end

  private

  def set_user
    @user = current_user
  end
end
