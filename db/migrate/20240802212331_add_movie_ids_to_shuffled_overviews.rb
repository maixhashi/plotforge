class AddMovieIdsToShuffledOverviews < ActiveRecord::Migration[7.1]
  def change
    add_column :shuffled_overviews, :movie_ids, :json
  end
end
