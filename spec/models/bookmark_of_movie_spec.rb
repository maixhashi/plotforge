require 'rails_helper'

RSpec.describe BookmarkOfMovie, type: :model do
  # 共通のデータを定義
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:bookmark_of_movie) { build(:bookmark_of_movie, user: user, movie: movie) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(bookmark_of_movie).to be_valid
    end

    it 'is not valid without a user' do
      invalid_bookmark = build(:bookmark_of_movie, user: nil, movie: movie)
      expect(invalid_bookmark).not_to be_valid
    end

    it 'is not valid without a movie' do
      invalid_bookmark = build(:bookmark_of_movie, user: user, movie: nil)
      expect(invalid_bookmark).not_to be_valid
    end

    it 'is not valid if the same user bookmarks the same movie more than once' do
      create(:bookmark_of_movie, user: user, movie: movie)
      duplicate_bookmark = build(:bookmark_of_movie, user: user, movie: movie)
      expect(duplicate_bookmark).not_to be_valid
    end
  end

  # アソシエーションのテスト
  context 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to movie' do
      association = described_class.reflect_on_association(:movie)
      expect(association.macro).to eq :belongs_to
    end
  end

  # インデックスのテスト
  context 'indexes' do
    it 'has an index on user_id' do
      index = ActiveRecord::Base.connection.indexes('bookmark_of_movies').find { |i| i.name == 'index_bookmark_of_movies_on_user_id' }
      expect(index).not_to be_nil
    end

    it 'has an index on movie_id' do
      index = ActiveRecord::Base.connection.indexes('bookmark_of_movies').find { |i| i.name == 'index_bookmark_of_movies_on_movie_id' }
      expect(index).not_to be_nil
    end
  end
end
