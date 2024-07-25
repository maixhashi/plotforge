module SynopsisShuffler
  # Rubyでのデバッグ
  def self.shuffle_synopsis(movies, view_context)
    sentences_with_movies = []
    # color_classes = ['link-black', 'link-gray']

    movies.each do |movie|
      overview = movie['overview']
      movie_url = view_context.movie_url(movie['id'])
      movie_info = movie['title']
      movie_image_url = "https://image.tmdb.org/t/p/w500#{movie['poster_path']}"

      puts "Movie Info: #{movie_info}, Image URL: #{movie_image_url}" # デバッグ用

      overview.split(/(?<=[。！？、])/).each do |sentence|
        sentences_with_movies << { sentence: sentence, movie_url: movie_url, movie_info: movie_info, movie_image_url: movie_image_url }
      end
    end

    shuffled = sentences_with_movies.shuffle
    shuffled_synopsis = shuffled.each_with_index.map do |item, index|
      # color_class = color_classes[index % color_classes.length]
      # "<a href='#{item[:movie_url]}' class='#{color_class} movie-link' data-movie-info='#{item[:movie_info]}' data-movie-image='#{item[:movie_image_url]}'>#{item[:sentence]}</a>"
      "<a href='#{item[:movie_url]}' class='movie-link' data-movie-info='#{item[:movie_info]}' data-movie-image='#{item[:movie_image_url]}'>#{item[:sentence]}</a>"
    end.join(' ')

    shuffled_synopsis = if shuffled_synopsis.strip.match(/.*[。！？、]$/)
                          shuffled_synopsis
                        else
                          "#{shuffled_synopsis}。"
                        end

    shuffled_synopsis.html_safe
  end
end
