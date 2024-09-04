class AddRelatedMovieGenresToShuffledOverviews < ActiveRecord::Migration[7.1]
  def change
    add_column :shuffled_overviews, :related_movie_genres, :json
  end
end
