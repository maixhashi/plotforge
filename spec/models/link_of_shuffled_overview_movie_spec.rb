require 'rails_helper'

RSpec.describe LinkOfShuffledOverviewMovie, type: :model do
  let(:shuffled_overview) { create(:shuffled_overview) }
  let(:movie) { create(:movie) }

  describe 'Validations' do
    it 'is valid with a shuffled_overview and movie' do
      link = LinkOfShuffledOverviewMovie.new(shuffled_overview: shuffled_overview, movie: movie)
      expect(link).to be_valid
    end

  describe 'Associations' do
    it { should belong_to(:shuffled_overview) }
    it { should belong_to(:movie) }
  end
end
