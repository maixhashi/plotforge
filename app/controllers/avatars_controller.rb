class AvatarsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_user

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to mypage_path, notice: 'アバターが更新されました。'
    else
      render :edit
    end
  end

  private

  def user_params
    params.permit(:avatar)
  end

  def set_user
    @user = current_user
  end
end
