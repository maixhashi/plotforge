class CreateShuffledOverviewKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :shuffled_overview_keywords do |t|
      t.references :shuffled_overview, null: false, foreign_key: true
      t.references :keyword, null: false, foreign_key: true

      t.timestamps
    end
  end
end
