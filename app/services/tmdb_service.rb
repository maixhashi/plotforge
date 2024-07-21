class TmdbService
    include HTTParty
    require 'net/http'
    require 'json'
    base_uri TMDB_BASE_URL
  
    def initialize
        @api_key = TMDB_API_KEY
        @base_url = TMDB_BASE_URL
        @options = { query: { api_key: TMDB_API_KEY, language: 'ja' } }
    end
  
    def fetch_movie_details(movie_id)
      self.class.get("/movie/#{movie_id}", @options)
    end
  
    def search_movies(query)
      @options[:query][:query] = query
      self.class.get('/search/movie', @options)
    end
    
    def random_movie
        response = fetch_movies
        movies = JSON.parse(response.body)['results']
        movies.sample # ランダムに1つの映画を返す
    end

    def random_movies(count)
        response = fetch_movies
        if response.success?
          movies = JSON.parse(response.body)['results']
      
          # `overview`が空でない映画だけをフィルタリング
          non_empty_overview_movies = movies.reject { |movie| movie['overview'].blank? }
      
          # デバッグ用にレスポンスを確認
          puts "Fetched movies with non-empty overview: #{non_empty_overview_movies.inspect}"
      
          # `count`個のランダムな映画を取得
          non_empty_overview_movies.sample(count)
        else
          # エラーハンドリング
          puts "Error fetching movies: #{response.status} - #{response.body}"
          []
        end
    end

    private

    # app/services/tmdb_service.rb
    def fetch_movies
        Faraday.get("#{@base_url}/movie/popular?api_key=#{@api_key}&language=ja")
    end
  end
  