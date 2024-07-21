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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end