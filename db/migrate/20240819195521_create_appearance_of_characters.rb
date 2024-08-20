class CreateAppearanceOfCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :appearance_of_characters do |t|
      t.references :character, null: false, foreign_key: true
      t.references :shuffled_overview, null: false, foreign_key: true

      t.timestamps
    end
  end
end
