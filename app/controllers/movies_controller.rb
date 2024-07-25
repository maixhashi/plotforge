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

    def show_random_movies
      self.clear_cache
      tmdb_service = TmdbService.new
      @movies = tmdb_service.random_movies(2)
  
      shuffled_synopsis = SynopsisShuffler.shuffle_synopsis(@movies, view_context)
      @shuffled_synopsis = shuffled_synopsis.html_safe

      self.clear_cache
    end

    def clear_cache
      Rails.cache.clear
    end
end
