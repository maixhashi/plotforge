class BookmarkOfMoviesController < ApplicationController
  before_action :set_movie, only: [:bookmark, :unbookmark]

  def bookmark
    current_user.bookmarked_movies << @movie unless current_user.bookmarked_movies.exists?(@movie.id)
    # 通常のレスポンスを返す
  end

  def unbookmark
    current_user.bookmarked_movies.delete(@movie) if current_user.bookmarked_movies.exists?(@movie.id)
    # 通常のレスポンスを返す
  end

  private

  def set_movie
    @movie = Movie.find_or_create_by(tmdb_id: params[:id])
  end
end
