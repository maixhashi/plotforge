class SettingsController < ApplicationController
    before_action :require_login
    before_action :set_setting, only: [:edit, :update]
  
    def index
      @settings = Setting.all
    end

    def edit
    end
  
    def update
      if @setting.update(setting_params)
        redirect_to root_path, notice: '設定が更新されました。'
      else
        render :edit
      end
    end
  
    private
  
    def set_setting
      @setting = current_user.setting || current_user.create_setting
    end
  
    def setting_params
      params.require(:setting).permit(:notification, :dark_mode)
    end
  end
  