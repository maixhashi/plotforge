require 'rails_helper'

RSpec.describe BookmarkOfShuffledOverview, type: :model do
  let(:user) { create(:user) }
  let(:shuffled_overview) { create(:shuffled_overview) }

  describe 'Validations' do
    it 'is valid with a user and shuffled_overview' do
      bookmark = BookmarkOfShuffledOverview.new(user: user, shuffled_overview: shuffled_overview)
      expect(bookmark).to be_valid
    end

    it 'does not allow a user to bookmark the same shuffled_overview more than once' do
      BookmarkOfShuffledOverview.create(user: user, shuffled_overview: shuffled_overview)
      duplicate_bookmark = BookmarkOfShuffledOverview.new(user: user, shuffled_overview: shuffled_overview)

      expect(duplicate_bookmark).not_to be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:shuffled_overview) }
  end
end
