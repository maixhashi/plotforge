class RenameMovieIdsToRelatedMovieIdsInShuffledOverviews < ActiveRecord::Migration[7.0]
  def change
    rename_column :shuffled_overviews, :movie_ids, :related_movie_ids
  end
end
