class BookmarkOfShuffledOverviewsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_user

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

    if params[:date]
      @grouped_bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews
      .where(bookmark_of_shuffled_overviews: { created_at: @date_range })
      .select('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.related_movie_ids, DATE(bookmark_of_shuffled_overviews.created_at) AS date, COUNT(*) AS count')
      .joins(:bookmark_of_shuffled_overviews)
      .group('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.related_movie_ids, DATE(bookmark_of_shuffled_overviews.created_at)')
      .each_with_object({}) do |overview, hash|
        date = overview.date
        hash[date] ||= []
        hash[date] << overview
      end
    else
      results = current_user.bookmarked_shuffled_overviews
      .select('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.related_movie_ids, DATE(bookmark_of_shuffled_overviews.created_at) AS date, COUNT(*) AS count')
      .joins(:bookmark_of_shuffled_overviews)
      .group('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.related_movie_ids, DATE(bookmark_of_shuffled_overviews.created_at)')

      # 結果をハッシュに変換
      @grouped_bookmarked_shuffled_overviews = results.each_with_object({}) do |overview, hash|
      date = overview.date
      hash[date] ||= []
      hash[date] << overview
      end

    end


    @grouped_bookmarked_shuffled_overviews.inspect

    render 'users/bookmark_of_shuffled_overviews/index'
  end
  
  def create
    @shuffled_overview = ShuffledOverview.find(params[:shuffled_overview_id])
  
    # 既にブックマークされているか確認
    unless current_user.bookmarked_shuffled_overviews.exists?(@shuffled_overview.id)
      current_user.bookmarked_shuffled_overviews << @shuffled_overview
    end
  
    respond_to do |format|
      format.html { render 'users/shuffled_overviews/show' }
      format.js   # create.js.erb を呼び出します
    end
  end
    
  def destroy
    # params[:id]が存在しない場合はparams[:shuffled_overview_id]を使用
    shuffled_overview_id = params[:shuffled_overview_id]
    @shuffled_overview = ShuffledOverview.find(shuffled_overview_id)

    if @shuffled_overview
      # 正しいカラムを使用して関連するbookmark_of_shuffled_overviewsを削除
      current_user.bookmark_of_shuffled_overviews.where(shuffled_overview_id: @shuffled_overview.id).destroy_all
      
      respond_to do |format|
        format.html { render 'users/shuffled_overviews/show' }
        format.js   # create.js.erb を呼び出します
      end
    else
      # レコードが見つからなかった場合の処理
      respond_to do |format|
        format.js { render js: "alert('ShuffledOverview not found');" }
      end
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
      bookmarked_shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
    
    @movies_data.inspect
    @movies_data['poster_path'].inspect
    
    @date_range = date.beginning_of_day..date.end_of_day

    @grouped_bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews
    .where(bookmark_of_shuffled_overviews: { created_at: @date_range })
    .select('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.related_movie_ids, DATE(bookmark_of_shuffled_overviews.created_at) AS date, COUNT(*) AS count')
    .joins(:bookmark_of_shuffled_overviews)
    .group('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.related_movie_ids, DATE(bookmark_of_shuffled_overviews.created_at)')
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



  def destroy
    # ユーザーのお気に入りからShuffledOverviewを削除する処理
    bookmark = current_user.bookmarked_shuffled_overviews.find_by(shuffled_overview_id: @shuffled_overview.id)
    
    if bookmark
      bookmark.destroy
      respond_to do |format|
        format.js { render :destroy }
      end
    else
      respond_to do |format|
        format.js { render js: "alert('Bookmark not found');" }
      end
    end
  end

  private

  def set_shuffled_overview
    @shuffled_overview = ShuffledOverview.find(params[:shuffled_overview_id])
  end

  def set_user
    @user = current_user
  end
