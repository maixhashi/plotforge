module MoviesHelper
    def genre_tags(genres)
      if genres.nil? || genres.empty?
        Rails.logger.debug "ジャンル情報がありません: genres=#{genres}"
        return 'ジャンル情報がありません'
      end
  
      Rails.logger.debug "genres: #{genres}"
  
      genre_tags = genres.map do |genre|
        content_tag(:span, genre['name'], class: 'genre-tag')
      end.join(' ')
  
      Rails.logger.debug "Genre tags: #{genre_tags}"
      genre_tags.html_safe
    end
  end
  