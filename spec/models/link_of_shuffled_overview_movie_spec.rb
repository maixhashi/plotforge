require 'rails_helper'

RSpec.describe LinkOfShuffledOverviewMovie, type: :model do
  let(:shuffled_overview) { create(:shuffled_overview) }
  let(:movie) { create(:movie) }

  describe 'Validations' do
    it 'is valid with a shuffled_overview and movie' do
      link = LinkOfShuffledOverviewMovie.new(shuffled_overview: shuffled_overview, movie: movie)
      expect(link).to be_valid
    end

    it 'does not allow the same shuffled_overview and movie combination more than once' do
      LinkOfShuffledOverviewMovie.create(shuffled_overview: shuffled_overview, movie: movie)
      duplicate_link = LinkOfShuffledOverviewMovie.new(shuffled_overview: shuffled_overview, movie: movie)

      expect(duplicate_link).not_to be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:shuffled_overview) }
    it { should belong_to(:movie) }
  end
end
