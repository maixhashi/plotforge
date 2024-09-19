require 'rails_helper'

RSpec.describe Character, type: :model do
  # モデルが存在することをテスト
  it 'is valid with valid attributes' do
    character = Character.new(name: 'John Doe')
    expect(character).to be_valid
  end

  # モデルが無効な属性である場合をテスト
  it 'is not valid without a name' do
    character = Character.new(name: nil)
    expect(character).not_to be_valid
  end

  # 関連付けのテスト
  describe 'associations' do
    it 'has many appearance_of_characters' do
      association = described_class.reflect_on_association(:appearance_of_character)
      expect(association.macro).to eq :has_many
    end

    it 'has many shuffled_overviews through appearance_of_characters' do
      association = described_class.reflect_on_association(:shuffled_overviews)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :appearance_of_character
    end
  end

  # インデックスが正しく設定されているかをテスト
  it 'has a name index' do
    column = ActiveRecord::Base.connection.columns('characters').find { |c| c.name == 'name' }
    expect(column).not_to be_nil
    index = ActiveRecord::Base.connection.indexes('characters').find { |i| i.name == 'index_characters_on_name' }
    expect(index).not_to be_nil
  end
  
  # Characterモデルの:nameカラムのレコードはuniqueである必要はないためテストから除外。 
    # it 'is not valid with a non-unique name' do
    #   Character.create!(name: 'UniqueName')
    #   character = Character.new(name: 'UniqueName')
    #   expect(character).not_to be_valid
    # end
end
