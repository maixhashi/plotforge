class RelatedMoviesController < ApplicationController
  before_action :set_user

  def index
    @start_date = params.fetch(:start_date, Date.today)
    
    # 現在のユーザーのシャッフルされたあらすじを取得
    @shuffled_overviews = current_user.shuffled_overviews

    # 映画データを取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end


    @grouped_overviews_with_movie_counts = ShuffledOverview
    .joins("CROSS JOIN JSON_TABLE(movie_ids, '$[*]' COLUMNS (movie_id BIGINT PATH '$')) AS movies")
    .group_by_day(:created_at)
    .count("movies.movie_id")

    render 'users/related_movies/index'

    respond_to do |format|
      format.html 
      format.js   # 必要に応じてJSテンプレートも対応
    end
  end

  def create
    content = shuffled_overview_params[:content]
    movie_ids = shuffled_overview_params[:movie_ids].map(&:to_i)
  
    @shuffled_overview = current_user.shuffled_overviews.build(content: content, movie_ids: movie_ids)
  
    if @shuffled_overview.save
      Rails.logger.debug "ShuffledOverview movie_ids: #{@shuffled_overview.movie_ids.inspect}"
      logger.debug("ShuffledOverview ID after save: #{@shuffled_overview.id}")
      
      render json: { message: 'Shuffled overview saved successfully' }, status: :ok
    else
      render json: { errors: @shuffled_overview.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def filter_movies_by_date
    # 日付パラメータが存在しない場合は Date.today を使用
    date_param = params[:date].presence || Date.today.to_s
  
    begin
      date = date_param.to_date
    rescue ArgumentError
      date = Date.today
    end

    start_time = date.beginning_of_day
    end_time = date.end_of_day

    @start_date = params.fetch(:start_date, Date.today)
    @shuffled_overviews = current_user.shuffled_overviews


    @grouped_overviews_with_movie_counts = ShuffledOverview
    .joins("CROSS JOIN JSON_TABLE(movie_ids, '$[*]' COLUMNS (movie_id BIGINT PATH '$')) AS movies")
    .group_by_day(:created_at)
    .count("movies.movie_id")


    # 映画データを再取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end

    puts @grouped_overviews_with_movie_counts.inspect 

    
    respond_to do |format|
      format.html { render 'users/related_movies/index' }
      format.js   { render :filter_movies_by_date }
    end
    
  end
  



  private

  def set_user
    @user = current_user
  end

  def shuffled_overview_params
    params.require(:shuffled_overview).permit(:content, movie_ids:[])
  end

end
