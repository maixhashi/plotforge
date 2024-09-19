require 'rails_helper'

RSpec.describe AppearanceOfCharacter, type: :model do
  let(:character) { create(:character) }
  let(:shuffled_overview) { create(:shuffled_overview) }
  let(:appearance_of_character) { create(:appearance_of_character, character: character, shuffled_overview: shuffled_overview) }
  
  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(appearance_of_character).to be_valid
    end

    it 'is invalid without a character' do
      appearance_of_character.character = nil
      expect(appearance_of_character).not_to be_valid
    end

    it 'is invalid without a shuffled_overview' do
      appearance_of_character.shuffled_overview = nil
      expect(appearance_of_character).not_to be_valid
    end
  end
  
  describe 'Associations' do
    it { should belong_to(:character) }
    it { should belong_to(:shuffled_overview) }
  end
end
