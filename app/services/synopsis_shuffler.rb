module SynopsisShuffler
    def self.shuffle_synopsis(movies, view_context)
      sentences_with_movies = []
      color_classes = ['link-black', 'link-gray']
  
      movies.each do |movie|
        overview = movie['overview']
        movie_url = view_context.movie_url(movie['id'])
        # 正規表現を修正して「、」も区切りに含める
        overview.split(/(?<=[。！？、])/).each do |sentence|
          sentences_with_movies << { sentence: sentence, movie_url: movie_url }
        end
      end
  
      shuffled = sentences_with_movies.shuffle
      shuffled_synopsis = shuffled.each_with_index.map do |item, index|
        color_class = color_classes[index % color_classes.length]
        "<a href='#{item[:movie_url]}' class='#{color_class}'>#{item[:sentence]}</a>"
      end.join(' ')
  
      # 最後が「。」「！」「？」で終わるかを確認し、終わっていない場合のみ「。」を追加
      shuffled_synopsis = if shuffled_synopsis.strip.match(/.*[ 。！？]$/)
                            shuffled_synopsis
                          else
                            "#{shuffled_synopsis}。"
                          end
  
      shuffled_synopsis
    end
  end
  