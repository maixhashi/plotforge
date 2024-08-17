module OverviewShuffler
  def self.shuffle_overview(movies, view_context)
    sentences_with_movies = []

    movies.each do |movie|
      movie_id = movie['id']
      overview = movie['overview']
      related_movie_url = view_context.url_for(controller: 'related_movies', action: 'show', id: movie['id'])
      movie_info = movie['title']
      movie_image_url = "https://image.tmdb.org/t/p/w500#{movie['poster_path']}"

      puts "Movie Info: #{movie_info}, Image URL: #{movie_image_url}" # デバッグ用

      overview.split(/(?<=[。！？、])/).each do |sentence|
        sentences_with_movies << { 
          movie_id: movie_id,
          sentence: sentence, 
          movie_url: related_movie_url, 
          movie_info: movie_info, 
          movie_image_url: movie_image_url
        }
      end
    end

    shuffled = sentences_with_movies.shuffle
    shuffled_overview = shuffled.each_with_index.map do |item, index|
      "<a href='#{item[:movie_url]}' class='movie-link' data-movie-id='#{item[:movie_id]}' data-movie-info='#{item[:movie_info]}' data-movie-image='#{item[:movie_image_url]}'>#{item[:sentence]}</a>"
    end.join(' ')

    shuffled_overview = if shuffled_overview.strip.match(/.*[。！？、]$/)
                          shuffled_overview
                        else
                          "#{shuffled_overview}。"
                        end

    shuffled_overview.html_safe
  end
end
