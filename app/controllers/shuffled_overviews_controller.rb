class ShuffledOverviewsController < ApplicationController
  before_action :set_user

  def index
    @start_date = params.fetch(:start_date, Date.today).to_date
    @shuffled_overviews = current_user.shuffled_overviews
    @grouped_overviews = current_user.shuffled_overviews.group_by_day(:created_at).count
    render 'users/shuffled_overviews/index'
    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
    end
  end

  def create
    content = shuffled_overview_params[:content]
    movie_ids = shuffled_overview_params[:movie_ids].map(&:to_i)
  
    @shuffled_overview = current_user.shuffled_overviews.build(content: content, movie_ids: movie_ids)
  
    if @shuffled_overview.save
      Rails.logger.debug "ShuffledOverview movie_ids: #{@shuffled_overview.movie_ids.inspect}"
      logger.debug("ShuffledOverview ID after save: #{@shuffled_overview.id}")
  
      render json: { message: 'Shuffled overview saved successfully' }, status: :ok
    else
      render json: { errors: @shuffled_overview.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def filter_by_date
    @start_date = params.fetch(:start_date, Date.today).to_date
    @grouped_overviews = ShuffledOverview.group_by_day(:created_at).count
    @shuffled_overviews = ShuffledOverview.where(created_at: params[:date].to_date.all_day)

    respond_to do |format|
      format.html { render 'users/shuffled_overviews/index' }
      format.js   { render :filter_by_date }
    end
  end

  private

  def set_user
    @user = current_user
  end

  def shuffled_overview_params
    params.require(:shuffled_overview).permit(:content, movie_ids:[])
  end
end
