class AddProfileSentenceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :profile_sentence, :string
  end
end
