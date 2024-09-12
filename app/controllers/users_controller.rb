class UsersController < ApplicationController
  skip_before_action :require_login
  helper_method :movie_poster_path
  before_action :set_user
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(params[:user][:email], params[:user][:password])
      redirect_to root_path, notice: 'ユーザー登録しました。'
    else
      render :new
    end
  end

  # パスワード変更フォームを表示
  def edit_password
  end

  # パスワード変更の処理
  def update_password
    if current_user.update(password_params)
      redirect_to user_path(current_user), notice: 'パスワードが変更されました'
    else
      render :edit_password
    end
  end

  def mypage
    @bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews
    @shuffled_overviews = current_user.shuffled_overviews
    @shuffled_overviews_on_profile = current_user.shuffled_overviews.page(params[:shuffled_overviews_page]).per(5)
  
    # Bookmarked ShuffledOverviewsのIDを取得
    bookmarked_shuffled_overview_ids = current_user.bookmarked_shuffled_overviews.pluck(:shuffled_overview_id)
    
    # そのIDに基づいてShuffledOverviewを取得し、ページネーションを適用
    @bookmarked_shuffled_overviews_on_profile = ShuffledOverview.where(id: bookmarked_shuffled_overview_ids).page(params[:bookmarked_shuffled_overviews_page]).per(5)
  
    tmdb_service = TmdbService.new
    @movies_data = {}
    @movies_data_related_of_bookmarked_overviews = {}
  
    # ユニークな movie_id を取得する
    unique_movie_ids = @shuffled_overviews.flat_map(&:related_movie_ids).uniq
  
    # ユニークな movie_id を使って映画の詳細をフェッチ
    unique_movie_ids.each do |movie_id|
      @movies_data[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
    end
    @movies_array = @movies_data.values
    @paginated_movies = Kaminari.paginate_array(@movies_array).page(params[:movies_page]).per(12)
  
    @bookmarked_shuffled_overviews_on_profile.each do |shuffled_overview|
      shuffled_overview.related_movie_ids.each do |movie_id|
        @movies_data_related_of_bookmarked_overviews[movie_id] ||= tmdb_service.fetch_movie_details(movie_id)
      end
    end
  
    # Contributionカレンダーのためのデータを準備
    # `created_at`をキーとして、作成日ごとにShuffledOverviewをカウント
    @shuffled_overviews_by_date = current_user.shuffled_overviews.group_by { |overview| overview.created_at.to_date }
  
    # 日ごとのカウントを保持するハッシュ
    @shuffled_overviews_count_by_date = @shuffled_overviews_by_date.each_with_object({}) do |(date, overviews), hash|
      hash[date] = overviews.size
    end
  
    # ブックマークされた映画に関連する処理
    @bookmarked_movies_by_date = Hash.new { |hash, key| hash[key] = [] }
    current_user.bookmarked_movies.each do |movie|
      date = movie.created_at.to_date
      tmdb_id = movie.tmdb_id
      @bookmarked_movies_by_date[date] << tmdb_id
    end
  
    @bookmarked_movies_data = {}
    current_user.bookmarked_movies.each do |movie|
      tmdb_id = movie.tmdb_id
      @bookmarked_movies_data[tmdb_id] ||= tmdb_service.fetch_movie_details(tmdb_id)
    end
  end
  
  def movie_poster_path(tmdb_id)
    # TMDB から映画の詳細を取得するメソッドがあると仮定
    tmdb_service = TmdbService.new
    movie = tmdb_service.fetch_movie_details(tmdb_id)
    movie['poster_path'] if movie
  end
      
  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end