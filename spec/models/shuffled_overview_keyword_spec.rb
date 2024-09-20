require 'rails_helper'

RSpec.describe ShuffledOverviewKeyword, type: :model do
  let(:shuffled_overview) { create(:shuffled_overview) }
  let(:keyword) { create(:keyword) }
  let(:shuffled_overview_keyword) { create(:shuffled_overview_keyword) }

  context 'validations' do
    it 'is valid with valid shuffled_overview and keyword' do
      shuffled_overview_keyword = build(:shuffled_overview_keyword, shuffled_overview: shuffled_overview, keyword: keyword)
      expect(shuffled_overview_keyword).to be_valid
    end

    it 'is not valid if the same keyword is added to the same shuffled_overview more than once' do
      # 同じ組み合わせを作成
      create(:shuffled_overview_keyword, shuffled_overview: shuffled_overview, keyword: keyword)
      duplicate = build(:shuffled_overview_keyword, shuffled_overview: shuffled_overview, keyword: keyword)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:keyword_id]).to include("has already been added to this shuffled overview")
    end
  end

  context 'associations' do
    it 'belongs to shuffled_overview' do
      association = described_class.reflect_on_association(:shuffled_overview)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to keyword' do
      association = described_class.reflect_on_association(:keyword)
      expect(association.macro).to eq :belongs_to
    end
  end
end
