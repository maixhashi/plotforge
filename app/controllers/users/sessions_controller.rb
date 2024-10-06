class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest # ゲストユーザーの作成・検索処理
    sign_in user # Deviseを使ってログイン処理
    session[:tutorial_step] = 0 # チュートリアルのステップを初期化
    redirect_to tutorial_message_path # ログイン後、チュートリアルにリダイレクト
  end
end
