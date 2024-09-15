class FollowsController < ApplicationController
  before_action :set_user, only: [
    "index_followings",
    "index_followers",
  ]

  def index_followings
    @followings = @user.following.page(params[:followings_page]).per(10)
  end

  def index_followers
    @followers = @user.followers.page(params[:followers_page]).per(10)
  end

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    @user.create_notification_follow!(current_user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js   # JavaScriptリクエストに対してJavaScriptを返す
    end
  end

  def destroy
    @user = Follow.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js   # JavaScriptリクエストに対してJavaScriptを返す
    end
  end
end

private

def set_user
  if params[:user_id]
    @user = User.friendly.find(params[:user_id])
  else
    @user = current_user
  end
end
