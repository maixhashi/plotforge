class ShuffledOverviewsController < ApplicationController
  before_action :set_user
  before_action :set_start_date

  def index
    own_shuffled_overviews = @user.shuffled_overviews

    # フォローしているユーザーのシャッフルオーバービュー
    followed_user_ids = @user.following.pluck(:id)
    followed_users_shuffled_overviews = ShuffledOverview.where(user_id: followed_user_ids)

    # 自分とフォローしているユーザーのシャッフルオーバービューを結合
    @shuffled_overviews = own_shuffled_overviews.or(followed_users_shuffled_overviews)

    # 映画データを取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end

    # MySQL で日付ごとにカウントを取得
    @grouped_overviews = @shuffled_overviews
                         .select("DATE(created_at) AS date, COUNT(*) AS count")
                         .group("DATE(created_at)")
                         .map { |record| [record.date.to_date, record.count] }
                         .to_h

    render 'shuffled_overviews/index'

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
    end
  end

  def my_shuffled_overviews
    @shuffled_overviews = current_user.shuffled_overviews

    # 映画データを取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
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

    render 'users/shuffled_overviews/my_shuffled_overviews'
    
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
    Rails.logger.info("Received parameters: #{params.inspect}")
    @shuffled_overview = current_user.shuffled_overviews.build(shuffled_overview_params)
  
    related_movie_ids = shuffled_overview_params[:related_movie_ids].map(&:to_i)
    related_movie_ids.each do |related_movie_id|
      movie = Movie.find_or_create_by!(tmdb_id: related_movie_id)
      @shuffled_overview.movies << movie
    end
  
    if @shuffled_overview.save
      extract_characters
      extract_keywords

      flash[:notice] = 'あらすじが保存されました'
      render json: { message: flash[:notice], id: @shuffled_overview.id }, status: :ok
    else
      flash[:alert] = @shuffled_overview.errors.full_messages.join(', ')
      render json: { errors: flash[:alert] }, status: :unprocessable_entity
    end
  end

  def filter_shuffled_overviews_by_date
    Time.zone = 'UTC'
    
    # 日付パラメータが存在しない場合は Date.today を使用
    date_param = params[:date].presence || Date.today.to_s
    
    begin
      date = date_param.to_date
    rescue ArgumentError
      date = Date.today
    end
    date_range = date.beginning_of_day..date.end_of_day
    
    # 指定された日付範囲のデータを取得
    @shuffled_overviews = ShuffledOverview.where(created_at: date.all_day)
  
    # 映画データを再取得する
    tmdb_service = TmdbService.new
    @movies_data = {}
    @shuffled_overviews.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
    
    # MySQL で日付ごとにカウントを取得
    @grouped_overviews = ShuffledOverview
                          .where(created_at: date_range)
                          .select("DATE(created_at) AS date, COUNT(*) AS count")
                          .group("DATE(created_at)")
                          .map { |record| [record.date.to_date, record.count] }
                          .to_h

    @shuffled_overviews_on_timeline = @shuffled_overviews.page(params[:shuffled_overviews_page]).per(5)


    
    respond_to do |format|
      format.html { render 'users/shuffled_overviews/my_shuffled_overviews' }
      format.js   { render 'users/shuffled_overviews/filter_shuffled_overviews_by_date' }
    end
  end


  private

  
  def extract_keywords
    content = @shuffled_overview.content
    extracted_keywords = KeywordExtractorService.extract_and_assign_keywords(@shuffled_overview.content, @shuffled_overview)

    extracted_keywords.each do |extracted_keyword|
      keyword = Keyword.find_or_create_by(content: extracted_keyword)  # 名前からKeywordオブジェクトを検索または作成
      ShuffledOverviewKeyword.find_or_create_by(
        shuffled_overview: @shuffled_overview,
        keyword: keyword
      )
    end
  end

  def extract_characters
    content = @shuffled_overview.content
    character_names = CharacterExtractorService.extract_and_assign_characters(content)

    character_names.each do |character_name|
      character = Character.find_or_create_by(name: character_name)  # 名前からCharacterオブジェクトを検索または作成
      AppearanceOfCharacter.find_or_create_by(
        shuffled_overview: @shuffled_overview,
        character: character
      )
    end
  end
  
  def set_user
    @user = current_user
  end

  def set_start_date
    @start_date = params.fetch(:start_date, Date.today) 
  end

  def shuffled_overview_params
    params.require(:shuffled_overview).permit(
      :content,
      related_movie_ids: [],
      movie_ids: [],
      characters_attributes: [:id, :name, :_destroy]  # Character モデルの属性を追加
    )
  end
end
  