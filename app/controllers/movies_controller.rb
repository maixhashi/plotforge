class MoviesController < ApplicationController
  def show
    tmdb_service = TmdbService.new
    @movie = tmdb_service.fetch_movie_details(params[:id])
    Rails.logger.debug "Movie details: #{@movie}"
  end

  def search
    tmdb_service = TmdbService.new
    @results = tmdb_service.search_movies(params[:query])
  end

  def show_random
    tmdb_service = TmdbService.new
    @movie = tmdb_service.random_movie
  end

  def show_multiple_random
    tmdb_service = TmdbService.new
    @movies = tmdb_service.random_movies(5)
  end

  def show_shuffled_overview
    clear_cache
    tmdb_service = TmdbService.new
    @movies = tmdb_service.random_movies(2)

    shuffled_overview = OverviewShuffler.shuffle_overview(@movies, view_context)
    @shuffled_overview = shuffled_overview.html_safe

    clear_cache
  end

  def clear_cache
    Rails.cache.clear
  end
end
