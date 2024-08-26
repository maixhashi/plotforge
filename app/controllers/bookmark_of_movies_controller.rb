class BookmarkOfMoviesController < ApplicationController
  before_action :set_movie, only: [:bookmark, :unbookmark]
  helper_method :movie_poster_path

  def index
    Time.zone = 'UTC'
    date_param = params[:date].presence || Date.current.to_s
        
    begin
      date = date_param.to_date
    rescue ArgumentError
      date = Date.cuurent
    end
    
    date_range = date.beginning_of_day..date.end_of_day

    # @grouped_bookmarked_movies = current_user.bookmarked_movies
    # .select('DATE(bookmark_of_movies.created_at) AS date, COUNT(*) AS count')
    # .joins(:bookmark_of_movies)
    # .group('DATE(bookmark_of_movies.created_at)')
    @grouped_bookmarked_movies = current_user.bookmarked_movies
      .select('DATE(bookmark_of_movies.created_at) AS date, movies.tmdb_id, COUNT(*) AS count')
      .joins(:bookmark_of_movies)
      .group('DATE(bookmark_of_movies.created_at), movies.tmdb_id')
  
    filtered_bookmarked_movies = current_user.bookmarked_movies
    .where(created_at: date_range)
    .select('DATE(bookmark_of_movies.created_at) AS date, movies.tmdb_id')
    .joins(:bookmark_of_movies)
    .group('DATE(bookmark_of_movies.created_at), movies.tmdb_id')

    # 常に配列を値として持つハッシュを初期化
    @bookmarked_movies_by_date = Hash.new { |hash, key| hash[key] = [] }

    filtered_bookmarked_movies.each do |movie|
      date = movie.date
      tmdb_id = movie.tmdb_id
      @bookmarked_movies_by_date[date] << tmdb_id
    end

    # ここで映画の数をカウント
    @bookmarked_movies_count_by_date = @bookmarked_movies_by_date.transform_values(&:size)
  
    render 'users/bookmark_of_movies/index'
  end
  
  def bookmark
    current_user.bookmarked_movies << @movie unless current_user.bookmarked_movies.exists?(@movie.id)
  end

  def unbookmark
    current_user.bookmarked_movies.delete(@movie) if current_user.bookmarked_movies.exists?(@movie.id)
  end
  
  def movie_poster_path(tmdb_id)
    # TMDB から映画の詳細を取得するメソッドがあると仮定
    tmdb_service = TmdbService.new
    movie = tmdb_service.fetch_movie_details(tmdb_id)
    movie['poster_path'] if movie
  end

  def filter_bookmarked_movies_by_date
    Time.zone = 'UTC'
    date_param = params[:date].presence || Date.current.to_s
        
    begin
      date = date_param.to_date
    rescue ArgumentError
      date = Date.cuurent
    end
    
    date_range = date.beginning_of_day..date.end_of_day
  
    filtered_bookmarked_movies = current_user.bookmarked_movies
      .where(created_at: date_range)
      .select('DATE(bookmark_of_movies.created_at) AS date, movies.tmdb_id')
      .joins(:bookmark_of_movies)
      .group('DATE(bookmark_of_movies.created_at), movies.tmdb_id')
  
    # 常に配列を値として持つハッシュを初期化
    @bookmarked_movies_by_date = Hash.new { |hash, key| hash[key] = [] }
  
    filtered_bookmarked_movies.each do |movie|
      date = movie.date
      tmdb_id = movie.tmdb_id
      @bookmarked_movies_by_date[date] << tmdb_id
    end
  
    if params[:date]
      filtered_bookmarked_movies = current_user.bookmarked_movies
      .joins(:bookmark_of_movies)
      .where(bookmark_of_movies: { created_at: date_range })
      .select('DATE(bookmark_of_movies.created_at) AS date, movies.tmdb_id')
      .group('DATE(bookmark_of_movies.created_at), movies.tmdb_id')
    
      @bookmarked_movies_by_date = Hash.new { |hash, key| hash[key] = [] }
    
      filtered_bookmarked_movies.each do |movie|
        date = movie.date
        tmdb_id = movie.tmdb_id
        @bookmarked_movies_by_date[date] << tmdb_id
      end 
    else
      filtered_bookmarked_movies = current_user.bookmarked_movies
      .select('DATE(bookmark_of_movies.created_at) AS date, movies.tmdb_id')
      .joins(:bookmark_of_movies)
      .group('DATE(bookmark_of_movies.created_at), movies.tmdb_id')
  
      # 常に配列を値として持つハッシュを初期化
      @bookmarked_movies_by_date = Hash.new { |hash, key| hash[key] = [] }
  
      filtered_bookmarked_movies.each do |movie|
        date = movie.date
        tmdb_id = movie.tmdb_id
        @bookmarked_movies_by_date[date] << tmdb_id
      end
    end
    # 日付ごとの映画数をカウント
    @bookmarked_movies_count_by_date = @bookmarked_movies_by_date.transform_values(&:size)
  
    respond_to do |format|
      format.html { render 'users/bookmark_of_movies/index' }
      format.js   { render 'users/bookmark_of_movies/filter_bookmarked_movies_by_date' }
    end
  end
  
  private

  def set_movie
    @movie = Movie.find_or_create_by(tmdb_id: params[:id])
  end

  
end
