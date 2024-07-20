class ApplicationController < ActionController::Base
    before_action :require_login
  
    private
  
    def require_login
      unless logged_in?
        redirect_to login_path, alert: "ログインが必要です。"
      end
    end
  
    def logged_in?
      !!current_user
    end
  
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
  