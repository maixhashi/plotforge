class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name

      t.timestamps
    end
    add_index :characters, :name
  end
end
