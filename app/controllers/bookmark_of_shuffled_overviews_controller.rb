class BookmarkOfShuffledOverviewsController < ApplicationController
  # before_action :authenticate_user!

  def create
    @shuffled_overview = ShuffledOverview.find(params[:shuffled_overview_id])
    current_user.bookmarked_shuffled_overviews << @shuffled_overview
    
    respond_to do |format|
      format.html { render 'users/shuffled_overviews/show' }
      format.js   # create.js.erb を呼び出します
    end
  end
  
  
  
  def destroy
    @shuffled_overview = ShuffledOverview.find(params[:id])
    current_user.bookmarked_shuffled_overviews.destroy(@shuffled_overview)
    
    respond_to do |format|
      format.html { render 'users/shuffled_overviews/show' }
      format.js   # create.js.erb を呼び出します
    end
  end
end
