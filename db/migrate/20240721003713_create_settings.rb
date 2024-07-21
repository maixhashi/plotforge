class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :notification
      t.boolean :dark_mode

      t.timestamps
    end
  end
end
