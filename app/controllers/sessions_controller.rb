class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    user = login(params[:email], params[:password])
    if user.present?
      redirect_to root_path, notice: 'ログインしました。'
    else
      redirect_to login_path, alert: 'ログインに失敗しました。'
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'ログアウトしました。'
  end
end
