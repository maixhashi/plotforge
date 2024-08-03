class ShuffledOverviewsController < ApplicationController
  before_action :set_user

  def index
    @start_date = params.fetch(:start_date, Date.today) 
    
    @shuffled_overviews = current_user.shuffled_overviews
  
    # 映画データを取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
  
    @grouped_overviews = current_user.shuffled_overviews.group_by_day(:created_at).count
    
    render 'users/shuffled_overviews/index'
    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
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
  
def filter_by_date
  # 日付パラメータが存在しない場合は Date.today を使用
  date_param = params[:date].presence || Date.today.to_s
  @start_date = params.fetch(:start_date, Date.today)
  
  begin
    date = date_param.to_date
  rescue ArgumentError
    date = Date.today
  end

  @shuffled_overviews = ShuffledOverview.where(created_at: date.all_day)

  Rails.logger.debug "params.fetch(:start_date, Date.today): #{params.fetch(:start_date, Date.today)}"
  Rails.logger.debug "@start_date: #{@start_date}"
  Rails.logger.debug "@shuffled_overviews: #{@shuffled_overviews}"
  Rails.logger.debug "params[:date]: #{params[:date]}"
  Rails.logger.debug "date.to_date.all_day: #{date.all_day}"
  
  # 映画データを再取得する
  tmdb_service = TmdbService.new
  @movies_data = {}
  @shuffled_overviews.each do |shuffled_overview|
    shuffled_overview.movie_ids.each do |movie_id|
      @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
    end
  end

  @grouped_overviews = current_user.shuffled_overviews.group_by_day(:created_at).count
  
  respond_to do |format|
    format.html { render 'users/shuffled_overviews/index' }
    format.js   { render :filter_by_date }
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
