class UsersController < ApplicationController
  skip_before_action :require_login
  helper_method :movie_poster_path

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

  def profile
    @bookmarked_shuffled_overviews = current_user.bookmarked_shuffled_overviews

    @shuffled_overviews = current_user.shuffled_overviews
    # <%= render partial: 'users/bookmark_of_shuffled_overviews/bookmarked_shuffled_overview_list_on_profile', locals: { bookmarked_shuffled_overviews: @msy_bookmarked_shuffled_overviews } %>で渡す変数
    results = current_user.bookmarked_shuffled_overviews
      .select('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.related_movie_ids, DATE(bookmark_of_shuffled_overviews.created_at) AS date, COUNT(*) AS count')
      .joins(:bookmark_of_shuffled_overviews)
      .group('shuffled_overviews.id, shuffled_overviews.content, shuffled_overviews.related_movie_ids, DATE(bookmark_of_shuffled_overviews.created_at)')
      .order('date DESC')
      .limit(4) # ここでレコードを5つに制限
  
    # 結果をハッシュに変換
    @grouped_bookmarked_shuffled_overviews = results.each_with_object({}) do |overview, hash|
      date = overview.date
      hash[date] ||= []
      hash[date] << overview
    end

    filtered_bookmarked_movies = current_user.bookmarked_movies
    .select('DATE(bookmark_of_movies.created_at) AS date, movies.tmdb_id')
    .joins(:bookmark_of_movies)
    .group('DATE(bookmark_of_movies.created_at), movies.tmdb_id')
    .limit(4)

    # 常に配列を値として持つハッシュを初期化
    @bookmarked_movies_by_date = Hash.new { |hash, key| hash[key] = [] }

    filtered_bookmarked_movies.each do |movie|
      date = movie.date
      tmdb_id = movie.tmdb_id
      @bookmarked_movies_by_date[date] << tmdb_id
    end

  end

  def movie_poster_path(tmdb_id)
    # TMDB から映画の詳細を取得するメソッドがあると仮定
    tmdb_service = TmdbService.new
    movie = tmdb_service.fetch_movie_details(tmdb_id)
    movie['poster_path'] if movie
  end
      
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end