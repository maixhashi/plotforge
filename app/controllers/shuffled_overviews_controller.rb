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
    @shuffled_overview = @user.shuffled_overviews.build(shuffled_overview_params)
    if @shuffled_overview.save
      render json: { message: 'Shuffled overview saved successfully' }, status: :created
    else
      render json: { errors: @shuffled_overview.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def shuffled_overview_params
    params.require(:shuffled_overview).permit(:content)
  end
end
