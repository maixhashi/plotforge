class TimelineController < ApplicationController
  before_action :set_user

  def index
    # 現在のユーザーがゲストユーザーかどうかを判定
    guest_user = User.find_by(email: 'guest@example.com')
  
    if current_user == guest_user
      # ゲストユーザーの場合、ゲストユーザー自身のShuffledOverviewのみ取得
      @shuffled_overviews = ShuffledOverview.where(user_id: current_user.id).order(created_at: :desc)
    else
      # 通常ユーザーの場合、フォロワーと自身のShuffledOverviewを取得し、ゲストユーザーのレコードを除外
      user_ids = [current_user.id] + current_user.following.pluck(:id)
  
      # ゲストユーザーのIDを除外
      guest_user_id = guest_user&.id
      @shuffled_overviews = ShuffledOverview.where(user_id: user_ids)
                                            .where.not(user_id: guest_user_id)
                                            .order(created_at: :desc)
    end
  
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
    # 現在のユーザーがゲストユーザーかどうかを判定
    guest_user = User.find_by(email: 'guest@example.com')

    if current_user == guest_user
      # ゲストユーザーの場合、ゲストユーザー自身のShuffledOverviewのみ取得
      @shuffled_overviews = ShuffledOverview.where(user_id: current_user.id).order(created_at: :desc)
    else
      # 通常ユーザーの場合、フォロワーと自身のShuffledOverviewを取得し、ゲストユーザーのレコードを除外
      user_ids = [current_user.id] + current_user.following.pluck(:id)
  
      # ゲストユーザーのIDを除外
      guest_user_id = guest_user&.id
      @shuffled_overviews = ShuffledOverview.where(user_id: user_ids)
                                            .where.not(user_id: guest_user_id)
                                            .order(created_at: :desc)
    end
  
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
    guest_user = User.find_by(email: 'guest@example.com')

    if current_user == guest_user
      # ゲストユーザーの場合、ゲストユーザー自身のShuffledOverviewのみ取得
      @shuffled_overviews = ShuffledOverview.where(user_id: current_user.id).order(created_at: :desc)
    else
      # 通常ユーザーの場合、フォロワーと自身のShuffledOverviewを取得し、ゲストユーザーのレコードを除外
      user_ids = [current_user.id] + current_user.following.pluck(:id)
  
      # ゲストユーザーのIDを除外
      guest_user_id = guest_user&.id
      @shuffled_overviews = ShuffledOverview.where(user_id: user_ids)
                                            .where.not(user_id: guest_user_id)
                                            .order(created_at: :desc)
    end
    
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
