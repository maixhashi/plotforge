class BookmarkOfShuffledOverviewsController < ApplicationController
  # before_action :authenticate_user!

  def create
    @shuffled_overview = ShuffledOverview.find(params[:shuffled_overview_id])
    current_user.bookmarked_shuffled_overviews << @shuffled_overview

    respond_to do |format|
      format.html { redirect_to user_shuffled_overview_path(params[:user_id], @shuffled_overview) }
      format.js   # create.js.erb をレンダリング
    end
  end

  def destroy
    @shuffled_overview = ShuffledOverview.find(params[:id])
    current_user.bookmarked_shuffled_overviews.destroy(@shuffled_overview)

    respond_to do |format|
      format.html { redirect_to user_shuffled_overview_path(params[:user_id], @shuffled_overview) }
      format.js   # destroy.js.erb をレンダリング
    end
  end
end
