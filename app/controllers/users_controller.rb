class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  helper_method :movie_poster_path
  before_action :set_user, only: [
    "mypage",
    "mypage_shuffled_overviews",
    "mypage_bookmarked_shuffled_overviews",
    "mypage_my_movies",
    "mypage_bookmarked_my_movies",
    "mypage_notifications"
  ]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      redirect_to root_path, notice: 'ユーザー登録しました。'
    else
      render :new
    end
  end

  def mypage
    @shuffled_overviews_on_profile = @user.shuffled_overviews.page(params[:shuffled_overviews_page]).per(5)

    tmdb_service = TmdbService.new
    @movies_data = {}

    # ユニークな movie_id を取得する
    unique_movie_ids = @shuffled_overviews_on_profile.flat_map(&:related_movie_ids).uniq

    # ユニークな movie_id を使って映画の詳細をフェッチ
    unique_movie_ids.each do |movie_id|
      @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
    end
    @movies_array = @movies_data.values
    @paginated_movies = Kaminari.paginate_array(@movies_array).page(params[:movies_page]).per(12)

    @notifications_on_mypage = @user.passive_notifications.page(params[:notifications_page]).per(20)
    @notifications_on_mypage.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def mypage_shuffled_overviews
    @shuffled_overviews_on_profile = @user.shuffled_overviews.page(params[:shuffled_overviews_page]).per(5)

    tmdb_service = TmdbService.new
    @movies_data = {}

    # ユニークな movie_id を取得する
    unique_movie_ids = @shuffled_overviews_on_profile.flat_map(&:related_movie_ids).uniq

    # ユニークな movie_id を使って映画の詳細をフェッチ
    unique_movie_ids.each do |movie_id|
      @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
    end
    @movies_array = @movies_data.values
    @paginated_movies = Kaminari.paginate_array(@movies_array).page(params[:movies_page]).per(12)
  end


  def mypage_bookmarked_shuffled_overviews
    # Bookmarked ShuffledOverviewsのIDを取得
    bookmarked_shuffled_overview_ids = @user.bookmarked_shuffled_overviews.pluck(:shuffled_overview_id)

    # そのIDに基づいてShuffledOverviewを取得し、ページネーションを適用
    @bookmarked_shuffled_overviews_on_profile = ShuffledOverview.where(id: bookmarked_shuffled_overview_ids).page(params[:bookmarked_shuffled_overviews_page]).per(5)

    tmdb_service = TmdbService.new
    @movies_data = {}

    # ユニークな movie_id を取得する
    unique_movie_ids = @bookmarked_shuffled_overviews_on_profile.flat_map(&:related_movie_ids).uniq

    # ユニークな movie_id を使って映画の詳細をフェッチ
    unique_movie_ids.each do |movie_id|
      @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
    end
    @movies_array = @movies_data.values
    @paginated_movies = Kaminari.paginate_array(@movies_array).page(params[:movies_page]).per(12)
  end

  def mypage_my_movies
    tmdb_service = TmdbService.new
    @movies_data = {}

    # ユニークな movie_id を取得する
    unique_movie_ids = @user.shuffled_overviews.flat_map(&:related_movie_ids).uniq

    # ユニークな movie_id を使って映画の詳細をフェッチ
    unique_movie_ids.each do |movie_id|
      @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
    end
    @movies_array = @movies_data.values
    @paginated_movies = Kaminari.paginate_array(@movies_array).page(params[:movies_page]).per(12)
  end
  
  def mypage_bookmarked_my_movies
    tmdb_service = TmdbService.new
    
    @bookmarked_movies_data = {}
    
    @user.bookmarked_movies.each do |movie|
      tmdb_id = movie.tmdb_id
      @bookmarked_movies_data[tmdb_id] ||= tmdb_service.fetch_movie_details(tmdb_id)
    end
    
    @movies_array = @bookmarked_movies_data.values
    @paginated_movies = Kaminari.paginate_array(@movies_array).page(params[:movies_page]).per(12)
  end

  def mypage_notifications
    @notifications_on_mypage = @user.passive_notifications.page(params[:notifications_page]).per(10)
    Rails.logger.debug "@notifications_on_mypage: #{@notifications_on_mypage.inspect}"
    Rails.logger.debug "notifications: #{@notifications_on_mypage.where.not(visitor_id: current_user.id).inspect}"
    @notifications_on_mypage.where(checked: false).each do |notification|
      notification.update(checked: true)
    end

    tmdb_service = TmdbService.new
    @movies_data = {}
    @notifications_on_mypage
    .where(action: 'bookmark-of-movie')
    .where.not(visitor_id: current_user.id).each do |notification_of_bookmarking_movie|
        @movies_data[notification_of_bookmarking_movie.movie_id] ||= tmdb_service.fetch_movie_details(notification_of_bookmarking_movie.movie_id)
    end
    
    @movies_data_related_of_shuffled_overviews = {}
    @notifications_on_mypage
    .where(action: 'bookmark-of-shuffled-overview')
    .where.not(visitor_id: current_user.id).each do |notification_of_shuffled_overview|
      notification_of_shuffled_overview.shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data_related_of_shuffled_overviews[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
    
  end

  def mark_as_read
    notification = @user.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to notifications_path
  end

  def movie_poster_path(tmdb_id)
    # TMDB から映画の詳細を取得するメソッドがあると仮定
    tmdb_service = TmdbService.new
    movie = tmdb_service.fetch_movie_details(tmdb_id)
    movie['poster_path'] if movie
  end
      
  private

  def set_user
    if params[:user_id]
      @user = User.friendly.find(params[:user_id])
    else
      @user = current_user
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_sentence)
  end
  
  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end