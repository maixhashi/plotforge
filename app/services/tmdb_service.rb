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
    response = self.class.get("/movie/#{movie_id}", @options)
    if response.success?
      movie_details = JSON.parse(response.body)
      Rails.logger.debug "Movie details fetched: #{movie_details}"
      movie_details
    else
      Rails.logger.error "Error fetching movie details: #{response.code} - #{response.body}"
      {}
    end
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

  def random_movies(count, max_pages = 500, pages_count = 3)
    pages = random_pages(max_pages, pages_count)
    movies = fetch_movies(pages)
  
    # `overview`が空でない映画だけをフィルタリング
    non_empty_overview_movies = movies.reject { |movie| movie['overview'].blank? }
  
    # デバッグ用にレスポンスを確認
    puts "Fetched movies with non-empty overview: #{non_empty_overview_movies.inspect}"
  
    # `count`個のランダムな映画を取得
    non_empty_overview_movies.sample(count)
  end

  def fetch_genres
    response = self.class.get('/genre/movie/list', @options)
    if response.success?
      genres = JSON.parse(response.body)['genres']
      Rails.logger.debug "Fetched genres: #{genres}"
      genres
    else
      Rails.logger.debug "Error fetching genres: #{response.status} - #{response.body}"
      []
    end
  end

  def fetch_movies(pages)
    all_movies = []
  
    pages.each do |page|
      response = Faraday.get("#{@base_url}/movie/popular?api_key=#{@api_key}&language=ja&page=#{page}", headers: { 'Cache-Control' => 'no-cache' })
      if response.success?
        movies = JSON.parse(response.body)['results']
        all_movies.concat(movies)
      else
        puts "Error fetching movies for page #{page}: #{response.status} - #{response.body}"
      end
    end
  
    all_movies
  end

  def random_pages(max_pages, count)
    (1..max_pages).to_a.sample(count)
  end
end
