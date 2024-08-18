class UsersController < ApplicationController
  skip_before_action :require_login

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
  end
      
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end