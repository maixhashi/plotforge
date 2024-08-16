class CreateLinkOfShuffledOverviewMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :link_of_shuffled_overview_movies do |t|
      t.references :shuffled_overview, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end

    add_index :link_of_shuffled_overview_movies, [:shuffled_overview_id, :movie_id], unique: true, name: 'index_shuffled_overview_movie_ids'
  end
end
