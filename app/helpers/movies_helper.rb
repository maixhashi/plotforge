module MoviesHelper
    def get_genre_names(genres)
      if genres.nil? || genres.empty?
        Rails.logger.debug "ジャンル情報がありません: genres=#{genres}"
        return 'ジャンル情報がありません'
      end
  
      Rails.logger.debug "genres: #{genres}"
  
      genre_names = genres.map do |genre|
        genre['name']
      end.join(', ')
  
      Rails.logger.debug "Genre names: #{genre_names}"
      genre_names
    end
  end
  