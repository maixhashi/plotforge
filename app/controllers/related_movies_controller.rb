class RelatedMoviesController < ApplicationController
  before_action :set_user
  before_action :set_movie, only: [:bookmark, :unbookmark]

  def index
    @start_date = params.fetch(:start_date, Date.today)
    
    # 現在のユーザーのシャッフルされたあらすじを取得
    @shuffled_overviews = current_user.shuffled_overviews
  
    # 映画データを取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
  
    # MySQL クエリで日付ごとの映画カウントを取得
    @grouped_overviews_with_movie_counts = ShuffledOverview
    .joins("CROSS JOIN JSON_TABLE(related_movie_ids, '$[*]' COLUMNS (related_movie_id BIGINT PATH '$')) AS movies")
    .select("DATE(created_at) AS date, COUNT(DISTINCT movies.related_movie_id) AS movie_count")
    .group("DATE(created_at)")
    .map { |record| [record.date, record.movie_count] }
    .to_h
    
    render 'users/related_movies/index'
  
    respond_to do |format|
      format.html 
      format.js   # 必要に応じてJSテンプレートも対応
    end
  end

  def show
    tmdb_service = TmdbService.new
    @related_movie = tmdb_service.fetch_movie_details(params[:id])
    Rails.logger.debug "RelatedMovie details: #{@related_movie}"
  end

  def show_shuffled_overview
    clear_cache
    tmdb_service = TmdbService.new
    @related_movies = tmdb_service.random_movies(2)

    shuffled_overview = OverviewShuffler.shuffle_overview(@related_movies, view_context)
    @shuffled_overview = shuffled_overview.html_safe
    
    clear_cache
  end

  def clear_cache
    Rails.cache.clear
  end

  def create
    content = shuffled_overview_params[:content]
    movie_ids = shuffled_overview_params[:related_movie_ids].map(&:to_i)
  
    @shuffled_overview = current_user.shuffled_overviews.build(content: content, related_movie_ids: related_movie_ids)
  
    if @shuffled_overview.save
      Rails.logger.debug "ShuffledOverview movie_ids: #{@shuffled_overview.movie_ids.inspect}"
      logger.debug("ShuffledOverview ID after save: #{@shuffled_overview.id}")
      
      render json: { message: 'Shuffled overview saved successfully' }, status: :ok
    else
      render json: { errors: @shuffled_overview.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def filter_movies_by_date
    Time.zone = 'UTC'
    # 日付パラメータが存在しない場合は Date.today を使用
    date_param = params[:date].presence || Date.today.to_s
    
    
    begin
      date = date_param.to_date
    rescue ArgumentError
      date = Date.today
    end
    
    @start_date = date
    date_range = date.beginning_of_day..date.end_of_day
    
    # 現在のユーザーのシャッフルされたあらすじを指定された日付でフィルタリング
    @shuffled_overviews = current_user.shuffled_overviews
    @grouped_overviews = current_user.shuffled_overviews.where(created_at: @start_date.beginning_of_day..@start_date.end_of_day)
  
    # MySQL クエリで日付ごとの映画カウントを取得
    @grouped_overviews_with_movie_counts = ShuffledOverview
    .where(created_at: date_range)
    .joins("CROSS JOIN JSON_TABLE(related_movie_ids, '$[*]' COLUMNS (related_movie_id BIGINT PATH '$')) AS movies")
    .select("DATE(created_at) AS date, COUNT(DISTINCT movies.related_movie_id) AS movie_count")
    .group("DATE(created_at)")
    .map { |record| [record.date, record.movie_count] }
    .to_h
  
    @grouped_overviews_with_movie_counts.inspect
    
    # 映画データを再取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    
    @grouped_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
  
    respond_to do |format|
      format.html { render 'users/related_movies/index' }
      format.js   { render 'users/shuffled_overviews/filter_movies_by_date' }
    end
  end

  def bookmark
    respond_to do |format|
      if current_user.bookmarked_movies.exists?(tmdb_id: @movie['id'])
        format.js { render js: "alert('Already bookmarked');" }
      else
        current_user.bookmarked_movies.create(tmdb_id: @movie['id'])
        format.js
      end
    end
  end

  def unbookmark
    respond_to do |format|
      bookmark = current_user.bookmarked_movies.find_by(tmdb_id: @movie['id'])
      movie = Movie.find_by(tmdb_id: @movie['id'])
      if bookmark
        # まず関連レコードを削除
        movie.link_of_shuffled_overview_movies.destroy_all
        
        # その後、ブックマークを削除
        bookmark.destroy
        
        format.js
      else
        format.js { render js: "alert('Not bookmarked');" }
      end
    end
  end

  
  private
  
  def set_user
    @user = current_user
  end
  
  def set_movie
    tmdb_service = TmdbService.new
    @movie = tmdb_service.fetch_movie_details(params[:id])
  end

  def shuffled_overview_params
    params.require(:shuffled_overview).permit(:content, related_movie_ids:[])
  end

end

