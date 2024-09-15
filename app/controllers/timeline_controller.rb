class TimelineController < ApplicationController
  before_action :set_user

  def index
    # 現在のユーザーとフォロワーのユーザーIDを取得
    user_ids = [current_user.id] + current_user.following.pluck(:id)

    # 取得したユーザーIDに基づいて、該当ユーザーのShuffledOverviewを取得
    @shuffled_overviews = ShuffledOverview.where(user_id: user_ids).order(created_at: :desc)

    # TMDBから映画の詳細情報を取得し、ユーザー情報を追加
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= {
          movie: tmdb_service.fetch_movie_details(movie_id),
          user: shuffled_overview.user
        }
      end
    end

    # ページネーションの適用
    @shuffled_overviews_on_timeline = Kaminari.paginate_array(@shuffled_overviews).page(params[:shuffled_overviews_page]).per(5)
  end

  def timeline_shuffled_overviews
    # 現在のユーザーとフォロワーのユーザーIDを取得
    user_ids = [current_user.id] + current_user.following.pluck(:id)

    # 取得したユーザーIDに基づいて、該当ユーザーのShuffledOverviewを取得
    @shuffled_overviews = ShuffledOverview.where(user_id: user_ids).order(created_at: :desc)

    # TMDBから映画の詳細情報を取得し、ユーザー情報を追加
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= {
          movie: tmdb_service.fetch_movie_details(movie_id),
          user: shuffled_overview.user
        }
      end
    end

    # ページネーションの適用
    @shuffled_overviews_on_timeline = Kaminari.paginate_array(@shuffled_overviews).page(params[:shuffled_overviews_page]).per(5)
  end

  def timeline_movies
    # 現在のユーザーとフォロワーのユーザーIDを取得
    user_ids = [current_user.id] + current_user.following.pluck(:id)

    # 取得したユーザーIDに基づいて、該当ユーザーのShuffledOverviewを取得
    @shuffled_overviews = ShuffledOverview.where(user_id: user_ids).order(created_at: :desc)

    # TMDBから映画の詳細情報を取得し、ユーザー情報を追加
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= {
          movie: tmdb_service.fetch_movie_details(movie_id),
          user: shuffled_overview.user
        }
      end
    end

    # ページネーションの適用
    @shuffled_overviews_on_timeline = Kaminari.paginate_array(@shuffled_overviews).page(params[:shuffled_overviews_page]).per(5)
  end

  private

  def set_user
    @user = current_user
  end
end
