class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Deviseのヘルパーメソッドを使用
  helper_method :user_signed_in?, :current_user

  # Deviseのストロングパラメーターの設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  
  # メソッドをDeviseのコールバックに追加
  before_action :configure_permitted_parameters, if: :devise_controller?
end
