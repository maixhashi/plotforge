class ApplicationController < ActionController::Base
    before_action :require_login
    helper_method :user_signed_in?, :current_user
  
    private
  
    def require_login
      unless logged_in?
        redirect_to login_path, alert: "ログインが必要です。"
      end
    end
  
    def logged_in?
      !!current_user
    end

    
    # ユーザーがサインインしているかどうかを判定
    def user_signed_in?
      current_user.present?
    end
  
    # 現在のユーザーを取得
    def current_user
      # 実際の実装に応じて変更してください
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
  
  end
  