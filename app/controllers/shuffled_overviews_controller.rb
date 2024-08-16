class ShuffledOverviewsController < ApplicationController
  before_action :set_user
  before_action :set_start_date

  def index
    @shuffled_overviews = current_user.shuffled_overviews

    # 映画データを取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end

    # MySQL で日付ごとにカウントを取得
    @grouped_overviews = current_user.shuffled_overviews
                                     .select("DATE(created_at) AS date, COUNT(*) AS count")
                                     .group("DATE(created_at)")
                                     .map { |record| [record.date.to_date, record.count] }
                                     .to_h

    @grouped_overviews.inspect

    render 'users/shuffled_overviews/index'
    
    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
    end
  end

  def show
    @shuffled_overview = ShuffledOverview.find(params[:id])

    render template: 'users/shuffled_overviews/show'
  end
  

  def create
    content = shuffled_overview_params[:content]
    related_movie_ids = shuffled_overview_params[:related_movie_ids].map(&:to_i)
  
    @shuffled_overview = current_user.shuffled_overviews.build(shuffled_overview_params)
  
    @shuffled_overview.related_movie_ids.each do |related_movie_id|
      movie = Movie.find_or_create_by!(tmdb_id: related_movie_id)
      @shuffled_overview.movies << movie
    end

    if @shuffled_overview.save
      Rails.logger.debug "ShuffledOverview related_movie_ids: #{@shuffled_overview.related_movie_ids.inspect}"
      Rails.logger.debug "ShuffledOverview movie_ids: #{@shuffled_overview.movie_ids.inspect}"
      logger.debug("ShuffledOverview ID after save: #{@shuffled_overview.id}")
  
      render json: { message: 'Shuffled overview saved successfully', id: @shuffled_overview.id }, status: :ok
    else
      render json: { errors: @shuffled_overview.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def filter_shuffled_overviews_by_date
    # 日付パラメータが存在しない場合は Date.today を使用
    date_param = params[:date].presence || Date.today.to_s
    
    begin
      date = date_param.to_date
    rescue ArgumentError
      date = Date.today
    end
  
    # 指定された日付範囲のデータを取得
    @shuffled_overviews = ShuffledOverview.where(created_at: date.all_day)
  
    # 映画データを再取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
    
    # MySQL で日付ごとにカウントを取得
    @grouped_overviews = ShuffledOverview
                          .where(created_at: date.all_day)
                          .select("DATE(created_at) AS date, COUNT(*) AS count")
                          .group("DATE(created_at)")
                          .map { |record| [record.date.to_date, record.count] }
                          .to_h
    
    respond_to do |format|
      format.html { render 'users/shuffled_overviews/index' }
      format.js   { render 'users/shuffled_overviews/filter_shuffled_overviews_by_date' }
    end
  end
  
  private

  def set_user
    @user = current_user
  end

  def set_start_date
    @start_date = params.fetch(:start_date, Date.today) 
  end

  def shuffled_overview_params
    params.require(:shuffled_overview).permit(:content, related_movie_ids:[], movie_ids:[])
  end

end
