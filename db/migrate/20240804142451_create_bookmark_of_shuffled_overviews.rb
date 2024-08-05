class CreateBookmarkOfShuffledOverviews < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmark_of_shuffled_overviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shuffled_overview, null: false, foreign_key: true
      t.timestamps
    end
    add_index :bookmark_of_shuffled_overviews, [:user_id, :shuffled_overview_id], unique: true, name: 'index_bookmarks_on_user_and_overview'
  end
end
