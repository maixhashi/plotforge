class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = login(params[:email], params[:password])
    if user
      redirect_to root_path, notice: 'ログインに成功しました。'
    else
      flash.now.alert = 'メールアドレスまたはパスワードが正しくありません。'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'ログアウトしました。'
  end
end
