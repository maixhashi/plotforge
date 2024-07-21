class MoviesController < ApplicationController
    def show
      tmdb_service = TmdbService.new
      @movie = tmdb_service.fetch_movie_details(params[:id])
    end
  
    def search
      tmdb_service = TmdbService.new
      @results = tmdb_service.search_movies(params[:query])
    end

    def show_random
      @movie = TmdbService.new.random_movie
    end

    def show_multiple_random
        @movies = TmdbService.new.random_movies(5) # 例えば5つの映画を取得
    end
  end
  