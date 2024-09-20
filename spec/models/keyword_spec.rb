require 'rails_helper'

RSpec.describe Keyword, type: :model do
  # バリデーションのテスト
  context 'validations' do
    it 'is valid with valid attributes' do
      keyword = build(:keyword) # FactoryBotを使用してkeywordを生成
      expect(keyword).to be_valid
    end

    it 'is not valid without content' do
      keyword = build(:keyword, content: nil) # contentをnilにして無効なkeywordを生成
      expect(keyword).not_to be_valid
    end

    # uniqueness validation : 同じキーワードであっても違うShuffledOverviewモデルから作成されたら区別されるようにしたい
      # it 'is not valid with duplicate content' do
      #   create(:keyword, content: 'duplicate_content') # 重複するcontentを持つkeywordを作成
      #   keyword = build(:keyword, content: 'duplicate_content') # 同じcontentで別のkeywordを作成
      #   expect(keyword).not_to be_valid
      # end
  end

  # アソシエーションのテスト
  context 'associations' do
    it 'has many shuffled_overview_keywords' do
      association = described_class.reflect_on_association(:shuffled_overview_keywords)
      expect(association.macro).to eq :has_many
    end

    it 'has many shuffled_overviews through shuffled_overview_keywords' do
      association = described_class.reflect_on_association(:shuffled_overviews)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :shuffled_overview_keywords
    end
  end
end
