class BookmarkOfShuffledOverviewsController < ApplicationController
  # before_action :authenticate_user!
  def index
    @bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews

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
    @grouped_bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews
    .select('shuffled_overviews.id, shuffled_overviews.content, DATE(bookmark_of_shuffled_overviews.created_at) AS date, COUNT(*) AS count')
    .joins(:bookmark_of_shuffled_overviews)
    .group('shuffled_overviews.id, shuffled_overviews.content, DATE(bookmark_of_shuffled_overviews.created_at)')
    .each_with_object({}) do |overview, hash|
      date = overview.date
      hash[date] ||= []
      hash[date] << overview
    end

    date_key = @grouped_bookmarked_shuffled_overviews.keys.first
    Rails.logger.debug "ShuffledOverview movie_ids: #{@grouped_bookmarked_overviews.inspect}"
                               

    render 'users/bookmark_of_shuffled_overviews/index'
  end
  
  def create
    @shuffled_overview = ShuffledOverview.find(params[:shuffled_overview_id])
    current_user.bookmarked_shuffled_overviews << @shuffled_overview
    
    respond_to do |format|
      format.html { render 'users/shuffled_overviews/show' }
      format.js   # create.js.erb を呼び出します
    end
  end
  
  
  
  def destroy
    @shuffled_overview = ShuffledOverview.find(params[:id])
    current_user.bookmarked_shuffled_overviews.destroy(@shuffled_overview)
    
    respond_to do |format|
      format.html { render 'users/shuffled_overviews/show' }
      format.js   # create.js.erb を呼び出します
    end
  end
  
  def filter_bookmarked_overviews_by_date
    # 日付パラメータが存在しない場合は Date.today を使用
    date_param = params[:date].presence || Date.today.to_s
    
    begin
      date = date_param.to_date
    rescue ArgumentError
      date = Date.today
    end
    
    @bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews
    
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
    @grouped_bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews
    .where(created_at: date.all_day)
    .select('shuffled_overviews.id, shuffled_overviews.content, DATE(bookmark_of_shuffled_overviews.created_at) AS date, COUNT(*) AS count')
    .joins(:bookmark_of_shuffled_overviews)
    .group('shuffled_overviews.id, shuffled_overviews.content, DATE(bookmark_of_shuffled_overviews.created_at)')
    .each_with_object({}) do |overview, hash|
      date = overview.date
      hash[date] ||= []
      hash[date] << overview
    end
    
    respond_to do |format|
      format.html { render 'users/bookmark_of_shuffled_overviews/index' }
      format.js   { render :filter_bookmarked_overviews_by_date }
    end
  end
  
  
end
