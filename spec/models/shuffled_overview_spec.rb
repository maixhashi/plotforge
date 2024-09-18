require 'rails_helper'

RSpec.describe ShuffledOverview, type: :model do
  let(:user) { create(:user) }
  let(:shuffled_overview) { create(:shuffled_overview, user: user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(shuffled_overview).to be_valid
    end

    it 'is invalid without content' do
      shuffled_overview.content = nil
      expect(shuffled_overview).to_not be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:bookmark_of_shuffled_overviews).dependent(:destroy) }
    it { should have_many(:users).through(:bookmark_of_shuffled_overviews) }
    it { should have_many(:link_of_shuffled_overview_movies).dependent(:destroy) }
    it { should have_many(:movies).through(:link_of_shuffled_overview_movies) }
    it { should have_many(:appearance_of_character).dependent(:destroy) }
    it { should have_many(:characters).through(:appearance_of_character) }
    it { should have_many(:shuffled_overview_keywords) }
    it { should have_many(:keywords).through(:shuffled_overview_keywords) }
    it { should have_many(:notifications).dependent(:destroy) }
  end

  describe '#create_notification_bookmark!' do
    let(:visitor) { create(:user) }

    it 'creates a new notification when not bookmarked before' do
      expect {
        shuffled_overview.create_notification_bookmark!(visitor)
      }.to change(Notification, :count).by(1)
    end

    it 'does not create a new notification if already bookmarked' do
      shuffled_overview.create_notification_bookmark!(visitor)
      expect {
        shuffled_overview.create_notification_bookmark!(visitor)
      }.to_not change(Notification, :count)
    end
  end
end
