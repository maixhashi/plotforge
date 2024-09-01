class TimelineController < ApplicationController
  before_action :set_user

  def index
    # 現在のユーザーとフォロワーのユーザーIDを取得
    user_ids = [current_user.id] + current_user.following.pluck(:id)

    # 取得したユーザーIDに基づいて、該当ユーザーのShuffledOverviewを取得
    @shuffled_overviews = ShuffledOverview.where(user_id: user_ids).order(created_at: :desc)
    @shuffled_overviews_on_timeline = @shuffled_overviews.page(params[:shuffled_overviews_page]).per(5)

    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

end
