class BookmarkOfShuffledOverviewsController < ApplicationController
  # before_action :authenticate_user!
  def index
    @bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews

    @grouped_bookmark_for_count = BookmarkOfShuffledOverview
    .where(user_id: current_user.id)
    .select("DATE(created_at) AS date, COUNT(*) AS count")
    .group("DATE(created_at)")
    .map { |record| [record.date.to_date, record.count] }
    .to_h

    @grouped_bookmark_for_count.inspect

    @shuffled_overviews = current_user.shuffled_overviews

    # 映画データを取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    date_param = params[:date].presence || Date.today.to_s

    begin
      date = date_param.to_date
    rescue ArgumentError
      date = Date.today
    end
    
    @date_range = date.beginning_of_day..date.end_of_day

    @grouped_bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews
    .where(bookmark_of_shuffled_overviews: { created_at: @date_range })
    .select('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.movie_ids, DATE(bookmark_of_shuffled_overviews.created_at) AS date, COUNT(*) AS count')
    .joins(:bookmark_of_shuffled_overviews)
    .group('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.movie_ids, DATE(bookmark_of_shuffled_overviews.created_at)')
    .each_with_object({}) do |overview, hash|
      date = overview.date
      hash[date] ||= []
      hash[date] << overview
    end

    @grouped_bookmarked_shuffled_overviews.inspect

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
    @grouped_bookmark_for_count = BookmarkOfShuffledOverview
    .where(user_id: current_user.id)
    .select("DATE(created_at) AS date, COUNT(*) AS count")
    .group("DATE(created_at)")
    .map { |record| [record.date.to_date, record.count] }
    .to_h

    @grouped_bookmark_for_count.inspect

    # 日付パラメータが存在しない場合は Date.today を使用
    Time.zone = 'UTC'
    date_param = params[:date].presence || Date.current.to_s
    
    begin
      date = date_param.to_date
    rescue ArgumentError
      date = Date.current
    end

    @bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews
    
    # 指定された日付範囲のデータを取得
    @shuffled_overviews = ShuffledOverview.where(created_at: date.all_day)
    
    # 映画データを再取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @bookmarked_shuffled_overviews.each do |bookmarked_shuffled_overview|
      bookmarked_shuffled_overview.movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
    
    @movies_data.inspect
    @movies_data['poster_path'].inspect
    
    @date_range = date.beginning_of_day..date.end_of_day

    @grouped_bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews
    .where(bookmark_of_shuffled_overviews: { created_at: @date_range })
    .select('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.movie_ids, DATE(bookmark_of_shuffled_overviews.created_at) AS date, COUNT(*) AS count')
    .joins(:bookmark_of_shuffled_overviews)
    .group('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.movie_ids, DATE(bookmark_of_shuffled_overviews.created_at)')
    .each_with_object({}) do |overview, hash|
      date = overview.date
      hash[date] ||= []
      hash[date] << overview
    end

    @grouped_bookmarked_shuffled_overviews.inspect
    
    respond_to do |format|
      format.html { render 'users/bookmark_of_shuffled_overviews/index' }
      format.js   { render :filter_bookmarked_overviews_by_date }
    end
  end
  
  
end
